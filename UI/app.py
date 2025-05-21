# app.py (uitgebreid met .gcode uploaden en versturen via MQTT)
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
from printer_files import fetch_files_from_printer
import threading
import time

UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

printers = []
PRINTER_FILE = "printers.json"

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
            def loop(printer):
                def inner():
                    while True:
                        huidige_status = printer["status"]
                        vorige_status = printer.get("vorige_status")

                        if huidige_status == "PRINTING":
                            printer["heeft_geprint"] = True

                        if (
                            printer["heeft_geprint"]
                            and vorige_status == "PRINTING"
                            and huidige_status in ["IDLE", "FINISH"]
                        ):
                            print(f"📦 [{printer['name']}] Print afgerond, wachten op afkoeling...")
                            printer["klaar_wachten_op_koeling"] = True

                        if printer["klaar_wachten_op_koeling"] and printer["bed_temp"] <= BED_TEMP_THRESHOLD:
                            print(f"✅ [{printer['name']}] Bed afgekoeld — schuif activeren...")
                            success = schuif_aansturen(printer["esp_ip"])
                            if success:
                                print("✅ Schuif automatisch gestart")
                            else:
                                print("❌ Schuif automatisch starten mislukt")
                            printer["klaar_wachten_op_koeling"] = False
                            printer["heeft_geprint"] = False

                        printer["vorige_status"] = huidige_status
                        time.sleep(2)
                threading.Thread(target=inner, daemon=True).start()
            loop(p)

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

@app.route("/printer/<printer_id>", methods=["GET", "POST"])
def printer_page(printer_id):
    message = ""

    if request.method == "POST":
        if 'file' not in request.files:
            message = "❌ Geen bestand meegegeven"
        else:
            file = request.files['file']
            if file.filename == '':
                message = "❌ Geen bestandsnaam"
            else:
                result = upload_file_to_printer(file)
                if result["success"]:
                    add_file_to_printer(printer_id, file.filename)
                    message = f"✅ Bestand geüpload: {file.filename}"
                else:
                    message = f"❌ Fout: {result['error']}"

    files = get_files_for_printer(printer_id)
    return render_template("printer.html", printer_id=printer_id, files=files, message=message)

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
    

def start_auto_trigger(printer):
    def loop():
        while True:
            huidige_status = printer["status"]
            vorige_status = printer.get("vorige_status")

            if huidige_status == "PRINTING":
                printer["heeft_geprint"] = True

            if (
                printer["heeft_geprint"]
                and vorige_status == "PRINTING"
                and huidige_status in ["IDLE", "FINISH"]
            ):
                print(f"📦 [{printer['name']}] Print afgerond, wachten op afkoeling...")
                printer["klaar_wachten_op_koeling"] = True

            if printer["klaar_wachten_op_koeling"] and printer["bed_temp"] <= BED_TEMP_THRESHOLD:
                print(f"✅ [{printer['name']}] Bed afgekoeld — schuif activeren...")
                success = schuif_aansturen(printer["esp_ip"])
                if success:
                    print("✅ Schuif automatisch gestart")
                else:
                    print("❌ Schuif automatisch starten mislukt")
                printer["klaar_wachten_op_koeling"] = False
                printer["heeft_geprint"] = False

            printer["vorige_status"] = huidige_status
            time.sleep(2)

    threading.Thread(target=loop, daemon=True).start()

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
        # Bestand staat nu al op de printer, we halen het live op via FTPS
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

@app.route("/")
def index():
    for p in printers:
        # Dynamisch bestanden ophalen via FTPS
        p["files"] = fetch_files_from_printer(p["ip"], "bblp", p["access_code"])
    return render_template("index.html", printers=printers)

if __name__ == "__main__":
    app.run(debug=True)
