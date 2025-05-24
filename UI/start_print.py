import json
import ssl
import time
import paho.mqtt.client as mqtt

def start_print(printer, filename):
    serial = printer["serial"]
    access_code = printer["access_code"]
    broker_ip = printer["ip"]
    topic = f"device/{serial}/request"

    subtask = filename.replace(".gcode.3mf", "")
    payload = {
        "print": {
            "command": "project_file",
            "param": "Metadata/plate_1.gcode",
            "url": f"ftp://{filename}",
            "subtask_name": subtask,
            "sequence_id": str(int(time.time()))
        }
    }

    # TLS setup
    context = ssl.create_default_context()
    context.check_hostname = False
    context.verify_mode = ssl.CERT_NONE

    client = mqtt.Client(protocol=mqtt.MQTTv311)
    client.username_pw_set("bblp", access_code)
    client.tls_set_context(context)

    def on_connect(client, userdata, flags, rc):
        print(f"✅ Verbonden met {broker_ip} — print starten...")
        client.publish(topic, json.dumps(payload))
        printer["heeft_geprint"] = True
        print(f"📨 Printopdracht verstuurd: {filename}")

    client.on_connect = on_connect
    client.connect(broker_ip, 8883, 60)
    client.loop_start()
    time.sleep(4)
    client.loop_stop()
    client.disconnect()