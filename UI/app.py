from flask import Flask, render_template, request, jsonify
from mqtt_listener import shared_state, start_mqtt
from controller import schuif_aansturen
from config import BED_TEMP_THRESHOLD
import threading
import time

app = Flask(__name__)
start_mqtt()

def auto_trigger_loop():
    while True:
        if shared_state["print_klaar"] and shared_state["bed_temp"] <= BED_TEMP_THRESHOLD:
            print("✅ Voorwaarden voldaan — schuif activeren...")
            if schuif_aansturen():
                print("✅ Schuif automatisch gestart")
            else:
                print("❌ Schuif automatisch starten mislukt")
            shared_state["print_klaar"] = False
        time.sleep(2)

threading.Thread(target=auto_trigger_loop, daemon=True).start()

@app.route("/data")
def data():
    return jsonify({
        "status": shared_state["status"],
        "bed_temp": shared_state["bed_temp"]
    })

@app.route("/", methods=["GET", "POST"])
def index():
    message = ""
    if request.method == "POST":
        if schuif_aansturen():
            message = "✅ Schuif geactiveerd!"
        else:
            message = "❌ Fout bij activeren schuif."

    auto_trigger = ""
    if shared_state["print_klaar"] and shared_state["bed_temp"] <= BED_TEMP_THRESHOLD:
        if schuif_aansturen():
            auto_trigger = "✅ Automatisch: Schuif gestart."
            shared_state["print_klaar"] = False
        else:
            auto_trigger = "❌ Automatisch activeren mislukt."

    return render_template("index.html",
        status=shared_state["status"],
        bed_temp=shared_state["bed_temp"],
        message=message,
        auto_trigger=auto_trigger
    )

if __name__ == "__main__":
    app.run(debug=True)