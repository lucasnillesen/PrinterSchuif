import time
import requests

def get_orders(token, retries=2, timeout=20):
    url = "https://api.bol.com/retailer/orders"
    headers = {
        "Accept": "application/vnd.retailer.v9+json",
        "Authorization": f"Bearer {token}"
    }
    backoff = 2
    for attempt in range(retries + 1):
        try:
            r = requests.get(url, headers=headers, timeout=timeout)
            if r.status_code == 429:
                retry_after = int(r.headers.get("Retry-After", "5"))
                time.sleep(retry_after)
                continue
            r.raise_for_status()
            return r.json().get("orders", [])
        except requests.HTTPError:
            if 500 <= r.status_code < 600 and attempt < retries:
                time.sleep(backoff); backoff *= 2
                continue
            raise
        except requests.RequestException:
            if attempt < retries:
                time.sleep(backoff); backoff *= 2
                continue
            raise
