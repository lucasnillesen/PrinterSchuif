# UI/UI/history.py
from pathlib import Path
import json, csv, io
from datetime import datetime

HISTORY_FILE = Path(__file__).resolve().parent / "print_history.json"

def _ensure_file():
    if not HISTORY_FILE.exists():
        HISTORY_FILE.write_text("[]", encoding="utf-8")

def append_history(record: dict):
    """record: {timestamp, ean, filename, quantity, printer_serial, orderItemId}"""
    _ensure_file()
    try:
        data = json.loads(HISTORY_FILE.read_text(encoding="utf-8"))
    except Exception:
        data = []
    data.append(record)
    if len(data) > 10000:
        data = data[-10000:]
    HISTORY_FILE.write_text(json.dumps(data, ensure_ascii=False, indent=0), encoding="utf-8")

def load_history(limit: int | None = None):
    _ensure_file()
    try:
        data = json.loads(HISTORY_FILE.read_text(encoding="utf-8"))
    except Exception:
        data = []
    data.sort(key=lambda r: r.get("timestamp",""), reverse=True)
    return data[:limit] if limit else data

def export_history_csv() -> bytes:
    rows = load_history()
    buf = io.StringIO()
    w = csv.DictWriter(buf, fieldnames=["timestamp","ean","filename","quantity","printer_serial","orderItemId"])
    w.writeheader()
    for r in rows:
        w.writerow({
            "timestamp": r.get("timestamp",""),
            "ean": r.get("ean",""),
            "filename": r.get("filename",""),
            "quantity": r.get("quantity",""),
            "printer_serial": r.get("printer_serial",""),
            "orderItemId": r.get("orderItemId",""),
        })
    return buf.getvalue().encode("utf-8")
