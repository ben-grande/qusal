import os
import requests


def get_access_token():
    client_id = os.environ('OAUTH_CLIENT_ID')
    client_secret = os.environ('OAUTH_CLIENT_SECRET')
    refresh_token = os.environ('OAUTH_REFRESH_TOKEN')

    # For Google (Gmail)
    requests.post(
        "https://oauth2.googleapis.com/token"
        data = {
            "client_id": client_id,
            "client_secret": client_secret,
            "refresh_token": refresh_token,
            "grant_type": "refresh_token"
        }
    )

    return response.json()['access_token']
