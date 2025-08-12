import os
import base64
from flask import Flask, render_template, request, redirect, url_for, flash, send_file, jsonify
from pathlib import Path
import json, io
from history import load_history, export_history_csv
from werkzeug.utils import secure_filename
from controller import schuif_aansturen, deur_openen, deur_dicht
from config import BED_TEMP_THRESHOLD
from mqtt_listener import PrinterClient
from ftps import upload_file_to_printer, delete_file_from_printer
from start_print import start_print
from queue_manager import get_queue, add_to_queue, remove_from_queue, save_queue, mark_current_done
from printer_files import fetch_files_from_printer
import threading
import requests
import time
from bol.watcher import BolOrderWatcher

UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

app = Flask(__name__)


MAPPING_PATH = Path(__file__).resolve().parent / "ean_mapping.json"

def read_mapping():
    if not MAPPING_PATH.exists():
        return {}
    try:
        return json.loads(MAPPING_PATH.read_text(encoding="utf-8"))
    except Exception:
        return {}

def write_mapping(mapping: dict):
    MAPPING_PATH.write_text(json.dumps(mapping, ensure_ascii=False, indent=2), encoding="utf-8")


app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

printers = []
PRINTER_FILE = "printers.json"

def start_auto_trigger(printer):
    def loop():
        while True:
            huidige_status = printer["status"]
            vorige_status = printer.get("vorige_status")

            # 📌 Print is bezig
            if huidige_status == "PRINTING":
                printer["heeft_geprint"] = True
                printer["klaar_wachten_op_koeling"] = False
                printer["schuif_bezig"] = False
                printer["schuif_commando_verstuurd"] = False

            # 📦 Print net afgerond
            if (
                printer["heeft_geprint"]
                and vorige_status == "PRINTING"
                and huidige_status in ["IDLE", "FINISH", "Onbekend"]
                and not printer["klaar_wachten_op_koeling"]
            ):
                print(f"☑️ [{printer['name']}] Print afgerond, wachten op afkoeling nu op dit moment...")
                success = deur_openen(printer["esp_ip"])
                if success:
                    print(f"✅ [{printer['name']}] Deur open commando verzonden")
                else:
                    print(f"❌ [{printer['name']}] Fout bij deur openen")
                printer["klaar_wachten_op_koeling"] = True
                

            # 🔪 Bed koel, schuif activeren
            queue = get_queue(printer["serial"])
            if queue:
                print(f"[{printer['name']}] Queue[0] = {queue[0]}")
                print(f"[{printer['name']}] min_bed_temp = {queue[0].get('min_bed_temp')}")
                print(f"[{printer['name']}] bed_temp = {printer['bed_temp']}")
                print(f"[{printer['name']}] BED_TEMP_THRESHOLD = {BED_TEMP_THRESHOLD}")
            try:
                min_temp = float(queue[0].get("min_bed_temp", BED_TEMP_THRESHOLD))
            except Exception:
                min_temp = BED_TEMP_THRESHOLD


            if (
                printer["klaar_wachten_op_koeling"]
                and printer["bed_temp"] <= min_temp
                and not printer["schuif_bezig"]
                and not printer["schuif_vastgelopen"]
                and not printer["schuif_commando_verstuurd"]
            ):
                print(f" [{printer['name']}] Bed koel genoeg, schuif activeren...")
                success = schuif_aansturen(printer["esp_ip"])
                if success:
                    printer["schuif_bezig"] = True
                    printer["schuif_commando_verstuurd"] = True
                    printer["klaar_wachten_op_koeling"] = False
                    print("✅ Schuifcommando verzonden")
                else:
                    print("❌ Fout bij verzenden schuifcommando")

            # ▶️ Volgende print starten
            if (
                printer["status"] in ["IDLE", "FINISH", "Onbekend"]
                and not printer["klaar_wachten_op_koeling"]
                and not printer["schuif_bezig"]
            ):
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
            time.sleep(2)
            print(f"[{printer['name']}] DEBUG: status={printer['status']} temp={printer['bed_temp']} wacht_op_afkoeling={printer['klaar_wachten_op_koeling']} schuif_bezig={printer['schuif_bezig']}")
    threading.Thread(target=loop, daemon=True).start()


@app.route("/schuif_feedback", methods=["POST"])
def schuif_feedback():
    data = request.get_json(force=True)
    status = data.get("status")
    esp_ip = request.remote_addr

    printer = next((p for p in printers if p["esp_ip"] == esp_ip), None)
    if not printer:
        print(f"❌ Geen printer gekoppeld aan IP: {esp_ip}")
        return jsonify({"result": "printer not found for IP"}), 404

    if status == "klaar":
        printer["schuif_bezig"] = False
        printer["klaar_wachten_op_koeling"] = False
        printer["heeft_geprint"] = False
        printer["schuif_commando_verstuurd"] = False
        deur_dicht(printer["esp_ip"])
        mark_current_done(printer["serial"])
    elif status == "vast":
        printer["schuif_bezig"] = True
        printer["schuif_vastgelopen"] = True
        printer["schuif_commando_verstuurd"] = False
        print(f"❌ [{printer['name']}] Schuif vastgelopen!")

    return jsonify({"result": "ok"})

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
                "heeft_geprint": False,
                "schuif_bezig": False,
                "schuif_vastgelopen": False,
                "schuif_commando_verstuurd": False 
            })
            printers.append(p)
            mqtt_instance = PrinterClient(p)
            mqtt_instance.start()
            p["mqtt_client_instance"] = mqtt_instance
            start_auto_trigger(p)

# === Start bol.com order watcher (EAN→3MF→queue) ===
try:
    try:
        from config import PRINTER_SERIAL as DEFAULT_PRINTER_SERIAL
    except Exception:
        DEFAULT_PRINTER_SERIAL = None

    # Fallback: pak eerste printer in lijst (als je die in app.py opbouwt)
    target_serial = None
    try:
        target_serial = printers[0]["serial"] if DEFAULT_PRINTER_SERIAL is None else DEFAULT_PRINTER_SERIAL
    except Exception:
        target_serial = DEFAULT_PRINTER_SERIAL

    if target_serial:
        _bol_watcher = BolOrderWatcher(printer_serial=target_serial, interval_sec=120, min_bed_temp=35.0)
        _bol_watcher.start()
    else:
        print("ℹ️ Geen printer serial gevonden voor BolOrderWatcher; watcher niet gestart.")
except Exception as _e:
    print(f"⚠️ Kon BolOrderWatcher niet starten: {_e}")


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
        "heeft_geprint": False,
        "schuif_bezig": False,
        "schuif_vastgelopen": False,
        "schuif_commando_verstuurd": False
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

    mqtt_instance = PrinterClient(new_printer)
    mqtt_instance.start()
    new_printer["mqtt_client_instance"] = mqtt_instance
    start_auto_trigger(new_printer)
    return redirect(url_for("index"))

@app.route("/remove_printer", methods=["POST"])
def remove_printer():
    serial = request.form.get("serial")
    if not serial:
        return "❌ Geen serial opgegeven", 400

    global printers

    # 📌 Zoek de printer die verwijderd moet worden
    printer = next((p for p in printers if p["serial"] == serial), None)
    if not printer:
        return "❌ Printer niet gevonden", 404

    # ✅ Stop de MQTT-client als die er is
    if "mqtt_client_instance" in printer:
        try:
            printer["mqtt_client_instance"].stop()
        except Exception as e:
            print(f"⚠️ Fout bij stoppen van MQTT-client: {e}")

    # 🗑️ Verwijder de printer uit de lijst
    printers = [p for p in printers if p["serial"] != serial]

    # 💾 Werk het json-bestand bij
    with open(PRINTER_FILE, "w") as f:
        json.dump([{
            "name": p["name"],
            "ip": p["ip"],
            "serial": p["serial"],
            "access_code": p["access_code"],
            "esp_ip": p["esp_ip"]
        } for p in printers], f, indent=2)

    print(f"🗑️ Printer met serial {serial} verwijderd en MQTT gestopt.")
    return redirect(url_for("index"))

@app.route("/deur_openen", methods=["POST"])
def deur_openen_route():
    serial = request.form["serial"]
    printer = next((p for p in printers if p["serial"] == serial), None)
    if printer:
        try:
            requests.get(f"http://{printer['esp_ip']}/deur_open", timeout=2)
        except Exception as e:
            print(f"❌ Fout bij openen deur: {e}")
    return redirect(url_for("index"))

@app.route("/deur_sluiten", methods=["POST"])
def deur_sluiten_route():
    serial = request.form["serial"]
    printer = next((p for p in printers if p["serial"] == serial), None)
    if printer:
        try:
            requests.get(f"http://{printer['esp_ip']}/deur_dicht", timeout=2)
        except Exception as e:
            print(f"❌ Fout bij sluiten deur: {e}")
    return redirect(url_for("index"))

@app.route("/add_to_queue", methods=["POST"])
def add_to_queue_route():
    serial = request.form["serial"]
    filename = request.form["filename"]
    count = int(request.form["count"])
    min_bed_temp = float(request.form["min_bed_temp"])  # Nieuw veld
    add_to_queue(serial, filename, count, min_bed_temp)
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
    if printer["status"] in ["IDLE", "FINISH", "FAILED", "Onbekend"] and not printer["klaar_wachten_op_koeling"]:
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

@app.route("/update_min_temp", methods=["POST"])
def update_min_temp():
    serial = request.form["serial"]
    filename = request.form["filename"]
    new_temp = float(request.form["min_bed_temp"])

    queue = get_queue(serial)
    for item in queue:
        if item["filename"] == filename:
            item["min_bed_temp"] = new_temp
            break
    save_queue({serial: queue})
    return redirect(url_for("index"))

@app.route("/move_up", methods=["POST"])
def move_up():
    serial = request.form["serial"]
    filename = request.form["filename"]

    queue = get_queue(serial)
    for i in range(1, len(queue)):
        if queue[i]["filename"] == filename:
            queue[i - 1], queue[i] = queue[i], queue[i - 1]
            break
    save_queue({serial: queue})
    return redirect(url_for("index"))

@app.route("/move_down", methods=["POST"])
def move_down():
    serial = request.form["serial"]
    filename = request.form["filename"]

    queue = get_queue(serial)
    for i in range(len(queue) - 1):
        if queue[i]["filename"] == filename:
            queue[i], queue[i + 1] = queue[i + 1], queue[i]
            break
    save_queue({serial: queue})
    return redirect(url_for("index"))

@app.route("/start_print", methods=["POST"])
def start_print_route():
    serial = request.form.get("serial")
    filename = request.form.get("filename")
    printer = next((p for p in printers if p["serial"] == serial), None)

    if not printer:
        print("❌ Printer niet gevonden voor serial:", serial)
        return "❌ Printer niet gevonden", 404
    try:
        start_print(printer, filename)
        return redirect(url_for("index"))
    except Exception as e:
        print(f"❌ Fout in start_print(): {e}")
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
            "bed_temp": p["bed_temp"],
            "mc_percent": p.get("mc_percent", 0)
        })
    return jsonify(simplified)

def collect_printer_files():
    for p in printers:
        try:
            p["files"] = fetch_files_from_printer(p["ip"], "bblp", p["access_code"])
        except Exception:
            p["files"] = []
    return printers

@app.route("/orders", methods=["GET"])
def orders():
    mapping = read_mapping()
    # normaliseer naar {ean, filename, printer_serial}
    mapping_list = []
    for k, v in mapping.items():
        if isinstance(v, dict):
            mapping_list.append({
                "ean": k,
                "filename": v.get("filename", ""),
                "printer_serial": v.get("printer_serial", "")
            })
        else:
            mapping_list.append({"ean": k, "filename": v, "printer_serial": ""})

    collect_printer_files()  # ook voor dropdown-bestanden
    items = load_history(limit=500)
    return render_template("orders.html",
                           mapping_list=sorted(mapping_list, key=lambda x: x["ean"]),
                           items=items,
                           printers=printers)



@app.post("/orders/map-add")
def orders_map_add():
    ean = (request.form.get("ean") or "").strip()
    filename = (request.form.get("filename") or "").strip()
    printer_serial = (request.form.get("printer_serial") or "").strip()

    if not ean or not filename:
        flash("Vul zowel EAN als bestand in.", "danger"); return redirect(url_for("orders"))
    if not ean.isdigit() or not (8 <= len(ean) <= 14):
        flash("EAN lijkt ongeldig. Alleen cijfers, 8–14 tekens.", "danger"); return redirect(url_for("orders"))
    if printer_serial and not any(p["serial"] == printer_serial for p in printers):
        flash("Onbekende printer.", "danger"); return redirect(url_for("orders"))

    mapping = read_mapping()
    mapping[ean] = {"filename": filename, "printer_serial": printer_serial}
    write_mapping(mapping)
    flash(f"Mapping toegevoegd: {ean} → {filename} ({printer_serial or '–'})", "success")
    return redirect(url_for("orders"))


@app.post("/orders/map-update")
def orders_map_update():
    original_ean = (request.form.get("original_ean") or "").strip()
    new_ean = (request.form.get("ean") or "").strip()
    filename = (request.form.get("filename") or "").strip()
    printer_serial = (request.form.get("printer_serial") or "").strip()

    if not original_ean:
        flash("Ontbrekende originele EAN.", "danger"); return redirect(url_for("orders"))
    if not new_ean or not new_ean.isdigit() or not (8 <= len(new_ean) <= 14):
        flash("Nieuwe EAN ongeldig. Alleen cijfers, 8–14 tekens.", "danger"); return redirect(url_for("orders"))
    if not filename:
        flash("Kies een bestand.", "danger"); return redirect(url_for("orders"))
    if printer_serial and not any(p["serial"] == printer_serial for p in printers):
        flash("Onbekende printer.", "danger"); return redirect(url_for("orders"))

    mapping = read_mapping()
    if original_ean not in mapping:
        flash("Originele EAN niet gevonden.", "danger"); return redirect(url_for("orders"))
    if new_ean != original_ean and new_ean in mapping:
        flash(f"EAN {new_ean} bestaat al.", "danger"); return redirect(url_for("orders"))

    if new_ean != original_ean:
        mapping.pop(original_ean, None)
    mapping[new_ean] = {"filename": filename, "printer_serial": printer_serial}
    write_mapping(mapping)
    flash(f"Mapping opgeslagen: {new_ean} → {filename} ({printer_serial or '–'})", "success")
    return redirect(url_for("orders"))


@app.post("/orders/map-delete")
def orders_map_delete():
    ean = (request.form.get("ean") or "").strip()
    if not ean:
        flash("Geen EAN opgegeven.", "danger"); return redirect(url_for("orders"))
    mapping = read_mapping()
    if ean in mapping:
        mapping.pop(ean)
        write_mapping(mapping)
        flash(f"Mapping verwijderd: {ean}", "success")
    else:
        flash("EAN niet gevonden.", "danger")
    return redirect(url_for("orders"))



@app.route("/orders/history.csv")
def orders_history_csv():
    csv_bytes = export_history_csv()
    return send_file(
        io.BytesIO(csv_bytes),
        mimetype="text/csv",
        as_attachment=True,
        download_name="print_history.csv",
    )

@app.route("/orders/mapping.json")
def orders_mapping_json():
    return jsonify(read_mapping())

@app.route("/queue")
def queue():
    # (voor nu) gewoon naar de homepage waar je de wachtrij al toont
    return redirect(url_for("index"))

@app.route("/")
def index():
    for p in printers:
        p["files"] = fetch_files_from_printer(p["ip"], "bblp", p["access_code"])
        p["queue"] = get_queue(p["serial"])
        try:
            resp = requests.get(f"http://{p['esp_ip']}/deur_status", timeout=1)
            p["deur_status"] = resp.json().get("deur_status", "onbekend")
        except:
            p["deur_status"] = "niet bereikbaar"
    return render_template("index.html", printers=printers)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)