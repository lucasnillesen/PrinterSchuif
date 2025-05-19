import paho.mqtt.client as mqtt
import ssl
import json
from config import MQTT_BROKER, PRINTER_SERIAL

# ✅ vul hier je gegevens in
MQTT_PORT = 8883
MQTT_USERNAME = "bblp"
MQTT_PASSWORD = "20217191"  # <-- vul in
#CA_CERT_PATH = "ca_cert.pem"  # moet in dezelfde map staan als dit script

shared_state = {
    "status": "Onbekend",
    "bed_temp": 0.0,
    "print_klaar": False
}

def on_message(client, userdata, msg):
    try:
        data = json.loads(msg.payload.decode())
        p = data.get("print", {})

        gcode_state = p.get("gcode_state", "")
        bed_temp = p.get("bed_temper", None)

        if gcode_state:
            shared_state["status"] = gcode_state
            if gcode_state in ["IDLE", "FINISH"]:
                shared_state["print_klaar"] = True

        if isinstance(bed_temp, (int, float)):
            shared_state["bed_temp"] = round(bed_temp, 1)
    except Exception as e:
        print("❌ Fout bij verwerken MQTT:", e)

def start_mqtt():
    client = mqtt.Client(protocol=mqtt.MQTTv311)
    client.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)

# ⛔ Verificatie uitzetten via custom SSLContext
    context = ssl.create_default_context()
    context.check_hostname = False
    context.verify_mode = ssl.CERT_NONE

    client.tls_set_context(context)

    client.on_message = on_message
    client.connect(MQTT_BROKER, MQTT_PORT)
    topic = f"device/{PRINTER_SERIAL}/report"
    client.subscribe(topic)
    client.loop_start()


