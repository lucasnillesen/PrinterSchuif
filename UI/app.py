import os
import json
import base64
from flask import Flask, render_template, request, jsonify, redirect, url_for
from werkzeug.utils import secure_filename
from controller import schuif_aansturen
from config import BED_TEMP_THRESHOLD
from mqtt_listener import PrinterClient
from ftps import upload_file_to_printer, delete_file_from_printer
from start_print import start_print
from queue_manager import get_queue, add_to_queue, remove_from_queue, save_queue
from printer_files import fetch_files_from_printer
import threading
import time

UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

printers = []
PRINTER_FILE = "printers.json"

def start_auto_trigger(printer):
    def loop():
        while True:
            huidige_status = printer["status"]
            vorige_status = printer.get("vorige_status")

            # Zet 'heeft_geprint' op True als er geprint is
            if huidige_status == "PRINTING":
                printer["heeft_geprint"] = True

            # Print is net afgelopen → wachten op afkoeling
            if (
                printer["heeft_geprint"]
                and vorige_status == "PRINTING"
                and huidige_status in ["IDLE", "FINISH"]
            ):
                print(f"📦 [{printer['name']}] Print afgerond, wachten op afkoeling...")
                printer["klaar_wachten_op_koeling"] = True

            # Wachten op afkoeling en bed is nu koel
            if printer["klaar_wachten_op_koeling"] and printer["bed_temp"] <= BED_TEMP_THRESHOLD:
                print(f"✅ [{printer['name']}] Bed afgekoeld — schuif activeren...")
                success = schuif_aansturen(printer["esp_ip"])
                if success:
                    print("✅ Schuif automatisch gestart")
                else:
                    print("❌ Schuif automatisch starten mislukt")
                    # Markeer huidige wachtrij-item als 'done'
                queue = get_queue(printer["serial"])
                if queue:
                    current = queue[0]
                    if current.get("status") == "printing":
                        current["printed"] += 1
                        current["status"] = "done"
                        save_queue({printer["serial"]: queue})
                        print(f"✅ [{printer['name']}] Print gemarkeerd als voltooid ({current['printed']}/{current['count']})")

                printer["klaar_wachten_op_koeling"] = False
                printer["heeft_geprint"] = False

            # ⬇️ Direct printen als printer IDLE is en klaar is met schuiven
            if printer["status"] in ["IDLE", "FINISH"] and not printer["klaar_wachten_op_koeling"]:
                queue = get_queue(printer["serial"])
                if queue:
                    current = queue[0]
                    if current["printed"] < current["count"] and current.get("status") != "printing":
                        print(f"📨 [{printer['name']}] Start print vanuit wachtrij: {current['filename']}")
                        current["status"] = "printing"
                        save_queue({printer["serial"]: queue})
                        try:
                            start_print(printer, current["filename"])
                        except Exception as e:
                            print(f"❌ Fout bij automatisch starten: {e}")

            printer["vorige_status"] = huidige_status
            print(f"[{printer['name']}] DEBUG: status={printer['status']} temp={printer['bed_temp']} wacht_op_afkoeling={printer['klaar_wachten_op_koeling']}")
            time.sleep(2)

    threading.Thread(target=loop, daemon=True).start()


if os.path.exists(PRINTER_FILE):
    with open(PRINTER_FILE, "r") as f:
        loaded = json.load(f)
        for p in loaded:
            p.update({
                "status": "Onbekend",
                "bed_temp": 0.0,
                "print_klaar": False,
                "klaar_wachten_op_koeling": False,
                "vorige_status": None,
                "heeft_geprint": False
            })
            printers.append(p)
            PrinterClient(p).start()
            start_auto_trigger(p)

@app.route("/add_printer", methods=["POST"])
def add_printer():
    name = request.form["name"]
    ip = request.form["ip"]
    serial = request.form["serial"]
    access_code = request.form["access_code"]
    esp_ip = request.form["esp_ip"]

    new_printer = {
        "name": name,
        "ip": ip,
        "serial": serial,
        "access_code": access_code,
        "esp_ip": esp_ip,
        "status": "Onbekend",
        "bed_temp": 0.0,
        "print_klaar": False,
        "klaar_wachten_op_koeling": False,
        "vorige_status": None,
        "heeft_geprint": False
    }
    printers.append(new_printer)

    with open(PRINTER_FILE, "w") as f:
        json.dump([{
            "name": p["name"],
            "ip": p["ip"],
            "serial": p["serial"],
            "access_code": p["access_code"],
            "esp_ip": p["esp_ip"]
        } for p in printers], f, indent=2)

    PrinterClient(new_printer).start()
    start_auto_trigger(new_printer)
    return redirect(url_for("index"))

@app.route("/add_to_queue", methods=["POST"])
def add_to_queue_route():
    serial = request.form["serial"]
    filename = request.form["filename"]
    count = int(request.form["count"])
    add_to_queue(serial, filename, count)
    return redirect(url_for("index"))

@app.route("/remove_from_queue", methods=["POST"])
def remove_from_queue_route():
    serial = request.form["serial"]
    filename = request.form["filename"]
    remove_from_queue(serial, filename)
    return redirect(url_for("index"))

@app.route("/start_queue", methods=["POST"])
def start_queue():
    serial = request.form["serial"]
    printer = next((p for p in printers if p["serial"] == serial), None)
    if not printer:
        return "❌ Printer niet gevonden", 404

    queue = get_queue(serial)
    print(f"🧪 Start wachtrij voor printer {printer['name']} — status={printer['status']} klaar_wachten_op_koeling={printer['klaar_wachten_op_koeling']}")
    print(f"📄 Wachtrij: {queue}")
    if printer["status"] in ["IDLE", "FINISH", "Onbekend"] and not printer["klaar_wachten_op_koeling"]:
        if queue:
            current = queue[0]
            if current["printed"] < current["count"] and current.get("status") != "printing":
                print(f"▶️ [{printer['name']}] Handmatig starten vanuit wachtrij: {current['filename']}")
                current["status"] = "printing"
                save_queue({printer["serial"]: queue})
                try:
                    start_print(printer, current["filename"])
                except Exception as e:
                    return f"❌ Fout bij starten: {e}", 500
    return redirect(url_for("index"))

@app.route("/start_print", methods=["POST"])
def start_print_route():
    serial = request.form.get("serial")
    filename = request.form.get("filename")
    printer = next((p for p in printers if p["serial"] == serial), None)
    if not printer:
        return "❌ Printer niet gevonden", 404
    try:
        start_print(printer, filename)
        return redirect(url_for("index"))
    except Exception as e:
        return f"❌ Fout bij printen: {e}", 500

@app.route("/upload", methods=["POST"])
def upload():
    if 'file' not in request.files or 'serial' not in request.form:
        return render_template("index.html", printers=printers, message="❌ Bestand of printer ontbreekt")

    file = request.files['file']
    serial = request.form['serial']
    printer = next((p for p in printers if p['serial'] == serial), None)

    if not printer:
        return render_template("index.html", printers=printers, message="❌ Printer niet gevonden")
    if file.filename == '':
        return render_template("index.html", printers=printers, message="❌ Geen bestandsnaam")

    result = upload_file_to_printer(file)
    if result["success"]:
        return redirect(url_for("index"))
    else:
        return render_template("index.html", printers=printers, message=f"❌ Fout: {result['error']}")

@app.route("/delete_file", methods=["POST"])
def delete_file():
    serial = request.form.get("serial")
    filename = request.form.get("filename")
    printer = next((p for p in printers if p["serial"] == serial), None)
    if not printer:
        return "❌ Printer niet gevonden", 404
    result = delete_file_from_printer(printer, filename)
    if result["success"]:
        return redirect(url_for("index"))
    else:
        return f"❌ Fout bij verwijderen: {result['error']}", 500

@app.route("/activate", methods=["POST"])
def activate():
    serial = request.form.get("serial")
    if not serial:
        return jsonify({"result": "missing_serial"})
    for p in printers:
        if p["serial"] == serial:
            success = schuif_aansturen(p["esp_ip"])
            return jsonify({"result": "ok" if success else "fail"})
    return jsonify({"result": "not found"})

@app.route("/data")
def data():
    simplified = []
    for p in printers:
        simplified.append({
            "name": p["name"],
            "serial": p["serial"],
            "status": p["status"],
            "bed_temp": p["bed_temp"]
        })
    return jsonify(simplified)

@app.route("/")
def index():
    for p in printers:
        p["files"] = fetch_files_from_printer(p["ip"], "bblp", p["access_code"])
        p["queue"] = get_queue(p["serial"])
    return render_template("index.html", printers=printers)

if __name__ == "__main__":
    app.run(debug=True)
