# app.py (nu met automatisch opslaan en herladen van printers)
import os
import json
from flask import Flask, render_template, request, jsonify, redirect, url_for
from controller import schuif_aansturen
from config import BED_TEMP_THRESHOLD
from mqtt_listener import PrinterClient
import threading
import time

app = Flask(__name__)

printers = []
PRINTER_FILE = "printers.json"

# ⬇️ Laad printers bij opstart
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

@app.route("/data")
def data():
    return jsonify(printers)

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

@app.route("/remove_printer", methods=["POST"])
def remove_printer():
    serial = request.form.get("serial")
    global printers

    new_list = []
    for p in printers:
        if p["serial"] == serial:
            print(f"🛑 Stop MQTT-client voor {p['name']}")
            mqtt_client = p.get("mqtt_client")
            if mqtt_client:
                try:
                    mqtt_client.loop_stop()
                    mqtt_client.disconnect()
                    print("✅ MQTT-client gestopt")
                except Exception as e:
                    print("❌ Fout bij stoppen MQTT-client:", e)
        else:
            new_list.append(p)

    printers = new_list

    # Sla aangepaste lijst op
    with open("printers.json", "w") as f:
        json.dump([{
            "name": p["name"],
            "ip": p["ip"],
            "serial": p["serial"],
            "access_code": p["access_code"],
            "esp_ip": p["esp_ip"]
        } for p in printers], f, indent=2)

    return redirect(url_for("index"))


@app.route("/")
def index():
    return render_template("index.html", printers=printers)

if __name__ == "__main__":
    app.run(debug=True)
