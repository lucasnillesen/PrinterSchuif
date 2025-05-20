import paho.mqtt.client as mqtt
import ssl
import json
import threading

class PrinterClient:
    def __init__(self, printer):
        self.printer = printer
        self.client = mqtt.Client(protocol=mqtt.MQTTv311)
        self.client.username_pw_set("bblp", printer["access_code"])
        self.client.on_message = self.on_message

        context = ssl.create_default_context()
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE
        self.client.tls_set_context(context)

        self.topic = f"device/{printer['serial']}/report"

    def on_message(self, client, userdata, msg):
        try:
            data = json.loads(msg.payload.decode())
            p = data.get("print", {})

            bed_temp = p.get("bed_temper")
            gcode_state = p.get("gcode_state", "")

            if isinstance(bed_temp, (int, float)):
                self.printer["bed_temp"] = round(bed_temp, 1)

            if gcode_state:
                self.printer["status"] = gcode_state
                if gcode_state == "RUNNING":
                    self.printer["heeft_geprint"] = True

        except Exception as e:
            print(f"❌ Fout bij {self.printer['name']}: {e}")

    def start(self):
        try:
            self.client.connect(self.printer["ip"], 8883)
            self.client.subscribe(self.topic)
            self.printer["mqtt_client"] = self.client  # ⬅️ voeg dit toe
            threading.Thread(target=self.client.loop_forever, daemon=True).start()
            print(f"✅ MQTT gestart voor {self.printer['name']}")
        except Exception as e:
            print(f"❌ Kon geen verbinding maken met {self.printer['name']}: {e}")
