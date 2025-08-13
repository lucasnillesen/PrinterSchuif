from controller import deur_openen
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
            mc_percent = p.get("mc_percent")
            if isinstance(mc_percent, int):
                self.printer["mc_percent"] = mc_percent

            if isinstance(bed_temp, (int, float)):
                self.printer["bed_temp"] = round(bed_temp, 1)

            if gcode_state:
                vorige_status = self.printer.get("status")
                self.printer["status"] = gcode_state

                if gcode_state == "RUNNING":
                    self.printer["heeft_geprint"] = True

                if (
                    self.printer["heeft_geprint"]
                    and vorige_status == "RUNNING"
                    and gcode_state in ["IDLE", "FINISH"]
                ):
                    print(f"📦 [{self.printer['name']}] Print klaar — wachten op afkoeling...")
    
                    success = deur_openen(self.printer["esp_ip"])
                    if success:
                        print(f"✅ [{self.printer['name']}] Deur open commando verzonden")
                    else:
                        print(f"❌ [{self.printer['name']}] Fout bij deur openen")

                    self.printer["klaar_wachten_op_koeling"] = True

        except Exception as e:
            print(f"❌ Fout bij {self.printer['name']}: {e}")

    def start(self):
        try:
            self.client.connect(self.printer["ip"], 8883)
            self.client.subscribe(self.topic)
            self.printer["mqtt_client"] = self.client
            threading.Thread(target=self.client.loop_forever, daemon=True).start()
            print(f"✅ MQTT gestart voor {self.printer['name']}")
        except Exception as e:
            print(f"❌ Kon geen verbinding maken met {self.printer['name']}: {e}")

    def _request_topic(self):
        serial = self.printer.get("serial")
        return f"device/{serial}/request" if serial else None

    def pause(self) -> bool:
        topic = self._request_topic()
        if not topic:
            return False
        payload = {"print": {"command": "pause"}}
        try:
            self.client.publish(topic, json.dumps(payload), qos=1)
            return True
        except Exception as e:
            print("MQTT pause error:", e)
            return False

    def resume(self) -> bool:
        topic = self._request_topic()
        if not topic:
            return False
        payload = {"print": {"command": "resume"}}
        try:
            self.client.publish(topic, json.dumps(payload), qos=1)
            return True
        except Exception as e:
            print("MQTT resume error:", e)
            return False

    def stop(self):
        try:
            self.client.disconnect()
            self.client.loop_stop()
            print(f"⛔️ MQTT gestopt voor {self.printer['name']}")
        except Exception as e:
            print(f"❌ Fout bij stoppen van MQTT voor {self.printer['name']}: {e}")
