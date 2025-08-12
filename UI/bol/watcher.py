import json
import threading
import time
from datetime import datetime, timedelta
from pathlib import Path

from .auth import get_access_token
from .orders import get_orders

PROCESSED_FILE = Path(__file__).resolve().parent.parent / "processed_orderitems.json"
MAPPING_FILE   = Path(__file__).resolve().parent.parent / "ean_mapping.json"

def load_processed_ids():
    if not PROCESSED_FILE.exists():
        return set()
    try:
        return set(json.loads(PROCESSED_FILE.read_text(encoding="utf-8")))
    except Exception:
        return set()

def save_processed_ids(ids):
    lst = list(ids)
    if len(lst) > 5000:
        lst = lst[-5000:]
    PROCESSED_FILE.write_text(json.dumps(lst), encoding="utf-8")

def load_mapping():
    if not MAPPING_FILE.exists():
        return {}
    try:
        return json.loads(MAPPING_FILE.read_text(encoding="utf-8"))
    except Exception:
        return {}

class BolOrderWatcher:
    """
    Pollt de bol.com Retailer API elke `interval_sec` seconden.
    Detecteert nieuwe orderItemIds; als er een mapping is voor de EAN, voegt hij toe aan de wachtrij.
    """
    def __init__(self, printer_serial: str, interval_sec: int = 120, min_bed_temp: float = 35.0):
        self.printer_serial = printer_serial
        self.interval = interval_sec
        self.min_bed_temp = min_bed_temp
        self._stop = threading.Event()
        self._thread = None

    def start(self):
        if self._thread and self._thread.is_alive():
            return
        self._stop.clear()
        self._thread = threading.Thread(target=self._run, daemon=True)
        self._thread.start()
        print(f"🔎 BolOrderWatcher gestart (interval {self.interval}s) → printer {self.printer_serial}")

    def stop(self):
        self._stop.set()
        if self._thread:
            self._thread.join(timeout=2)

    def _run(self):
        processed = load_processed_ids()
        token = None
        token_expiry = datetime.min

        while not self._stop.is_set():
            try:
                now_utc = datetime.utcnow()
                if token is None or now_utc > token_expiry - timedelta(seconds=60):
                    token = get_access_token()
                    token_expiry = now_utc + timedelta(minutes=9)  # ~10m geldigheid

                orders = get_orders(token)
                mapping = load_mapping()

                # Lazy import om circulaire import te voorkomen
                from queue_manager import add_to_queue, save_queue

                new_processed = set(processed)
                actions = 0

                for order in orders:
                    for item in order.get("orderItems", []):
                        iid = item.get("orderItemId")
                        if not iid or iid in processed:
                            continue
                        ean = item.get("ean")
                        qty = item.get("quantity", 1)
                        if ean and ean in mapping:
                            entry = mapping[ean]
                            if isinstance(entry, dict):
                                filename = entry.get("filename")
                                target_serial = entry.get("printer_serial") or self.printer_serial
                            else:
                                filename = entry
                                target_serial = self.printer_serial
                        
                            if filename:
                                try:
                                    add_to_queue(target_serial, filename, qty, self.min_bed_temp)
                                    save_queue()
                                    print(f"✅ Nieuwe bestelling → {filename} x{qty} → wachtrij printer {target_serial} (EAN {ean}, item {iid})")
                                    # (history) late import om import-issues te voorkomen
                                    try:
                                        from history import append_history
                                        append_history({
                                            "timestamp": datetime.utcnow().isoformat(timespec="seconds") + "Z",
                                            "orderItemId": iid,
                                            "ean": ean,
                                            "filename": filename,
                                            "quantity": qty,
                                            "printer_serial": target_serial,
                                        })
                                    except Exception as _hist_e:
                                        print(f"ℹ️ History log skipped: {_hist_e}")
                                except Exception as e:
                                    print(f"⚠️ Kon item niet toevoegen aan wachtrij: {e}")
                            else:
                                print(f"⚠️ Mapping zonder filename voor EAN {ean}")
                        else:
                            if ean:
                                print(f"⚠️ Geen mapping voor EAN {ean} (orderItemId {iid})")
                            else:
                                print(f"⚠️ Ontbrekende EAN voor orderItemId {iid}")
                        from history import append_history
                        append_history({
                            "timestamp": datetime.utcnow().isoformat(timespec="seconds") + "Z",
                            "orderItemId": iid,
                            "ean": ean,
                            "filename": filename,
                            "quantity": qty,
                            "printer_serial": self.printer_serial,
                        })

                        new_processed.add(iid)

                processed = new_processed
                # Altijd opslaan zodat we 'gezien' items niet blijven loggen
                save_processed_ids(processed)

            except Exception as ex:
                print(f"⚠️ Fout in BolOrderWatcher: {ex}")

            for _ in range(self.interval):
                if self._stop.is_set(): break
                time.sleep(1)
