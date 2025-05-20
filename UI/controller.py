import requests

def schuif_aansturen(ip):
    try:
        url = f"http://{ip}/push"
        print("➡️ Verzend naar ESP:", url)
        r = requests.get(url, timeout=2)
        print("⬅️ Antwoord ESP:", r.status_code, r.text)
        return r.status_code == 200
    except Exception as e:
        print("❌ Fout bij sturen schuif:", e)
        return False
