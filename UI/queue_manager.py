import os
import json

QUEUE_FILE = "queue.json"  # Pad relatief aan hoofdmap

# Zorg dat queue-bestand bestaat
if not os.path.exists(QUEUE_FILE):
    with open(QUEUE_FILE, "w") as f:
        json.dump({}, f)

def load_queue():
    with open(QUEUE_FILE, "r") as f:
        return json.load(f)

def save_queue(data):
    with open(QUEUE_FILE, "w") as f:
        json.dump(data, f, indent=2)

def get_queue(printer_serial):
    data = load_queue()
    return data.get(printer_serial, [])

def add_to_queue(printer_serial, filename, count):
    data = load_queue()
    queue = data.get(printer_serial, [])

    queue.append({
        "filename": filename,
        "count": count,
        "printed": 0,
        "status": "waiting" if not queue else "queued"
    })

    data[printer_serial] = queue
    save_queue(data)

def remove_from_queue(printer_serial, filename):
    data = load_queue()
    queue = data.get(printer_serial, [])
    queue = [item for item in queue if item["filename"] != filename]
    data[printer_serial] = queue
    save_queue(data)

def mark_print_done(printer_serial):
    data = load_queue()
    queue = data.get(printer_serial, [])
    if not queue:
        return

    item = queue[0]
    item["printed"] += 1

    if item["printed"] >= item["count"]:
        queue.pop(0)
    else:
        item["status"] = "waiting"

    if queue:
        queue[0]["status"] = "active"

    data[printer_serial] = queue
    save_queue(data)
