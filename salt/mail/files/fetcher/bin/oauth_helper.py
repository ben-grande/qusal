import os
import urllib.parse
import http.client
import json


def get_access_token():
    try:
        client_id = os.environ('OAUTH_CLIENT_ID')
        client_secret = os.environ('OAUTH_CLIENT_SECRET')
        refresh_token = os.environ('OAUTH_REFRESH_TOKEN')
    except KeyError as e:
        raise SystemExit(f"Missing environment variable: {e}")

    params = {
        "client_id": client_id,
        "client_secret": client_secret,
        "refresh_token": refresh_token,
        "grant_type": "refresh_token"
    }

    encoded_params = urllib.parse.encode(params)
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
    }

    # connect
    try:
        conn = http.client.HTTPSConnection("accounts.google.com")
        conn.request("POST", "/o/oauth2/token", encoded_params, headers)
        response = conn.getresponse()
        if response.status != 200:
            raise SystemExit(f"HTTP Error {response.status}: {response.reason}")

        data = json.loads(response.read())
        return data["access_token"]
    except Exception as e:
        raise SystemExit(f"Connection failed: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    print(get_access_token())
