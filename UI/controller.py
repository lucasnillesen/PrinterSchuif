import requests

def deur_openen(ip):
    try:
        url = f"http://{ip}/deur_open"
        print("Verzend naar ESP (deur):", url)
        r = requests.get(url, timeout=2)
        print("Antwoord ESP:", r.status_code, r.text)
        return r.status_code == 200
    except Exception as e:
        print("Fout bij openen deur:", e)
        return False

def schuif_aansturen(ip):
    try:
        url = f"http://{ip}/push"
        print("Verzend naar ESP (schuif):", url)
        r = requests.get(url, timeout=2)
        print("Antwoord ESP:", r.status_code, r.text)
        return r.status_code == 200
    except Exception as e:
        print("Fout bij sturen schuif:", e)
        return False
    
def deur_dicht(ip):
    try:
        url = f"http://{ip}/deur_dicht"
        print("Verzend naar ESP (deur dicht):", url)
        r = requests.get(url, timeout=2)
        print("Antwoord ESP:", r.status_code, r.text)
        return r.status_code == 200
    except Exception as e:
        print("Fout bij sluiten deur:", e)
        return False