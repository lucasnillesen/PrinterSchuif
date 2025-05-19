import requests
from config import ESP_IP

def schuif_aansturen():
    try:
        r = requests.get(f"http://{ESP_IP}/push", timeout=2)
        return r.status_code == 200
    except Exception as e:
        print("Fout bij sturen schuif:", e)
        return False