import os
import json

QUEUE_FILE = "queue.json"

# Laad wachtrijen uit bestand
if os.path.exists(QUEUE_FILE):
    with open(QUEUE_FILE, "r") as f:
        queues = json.load(f)
else:
    queues = {}

def save_queue(data=None):
    global queues
    if data:
        queues.update(data)
    with open(QUEUE_FILE, "w") as f:
        json.dump(queues, f, indent=2)

def get_queue(serial):
    return queues.get(serial, [])

def add_to_queue(serial, filename, count, min_bed_temp=35.0):
    if serial not in queues:
        queues[serial] = []
    queues[serial].append({
        "filename": filename,
        "count": count,
        "printed": 0,
        "status": "waiting",
        "min_bed_temp": min_bed_temp
    })
    save_queue(queues)

def remove_from_queue(serial, filename):
    if serial in queues:
        queues[serial] = [item for item in queues[serial] if item["filename"] != filename]
        save_queue()

def mark_current_done(serial):
    if serial not in queues or not queues[serial]:
        return

    current = queues[serial][0]
    current["printed"] = current.get("printed", 0) + 1
    current["status"] = "done" if current["printed"] >= current["count"] else "waiting"

    if current["printed"] >= current["count"]:
        queues[serial].pop(0)

    save_queue()
