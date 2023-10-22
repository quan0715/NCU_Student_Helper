import os
import requests
from django.conf import settings


class Auth:
    access_token = None

    @staticmethod
    def initialize():
        auth_url = 'https://tdx.transportdata.tw/auth/realms/TDXConnect/protocol/openid-connect/token'
        auth_header = {'content-type': 'application/x-www-form-urlencoded'}
        auth_data = {
            'grant_type': 'client_credentials',
            'client_id': settings.BUS_CLIENT_ID,
            'client_secret': settings.BUS_CLIENT_SECRET
        }
        Auth.access_token = requests.post(auth_url, data=auth_data, headers=auth_header).json()['access_token']

    @staticmethod
    def get_headers():
        if Auth.access_token is None:
            Auth.initialize()
        return {'authorization': f'Bearer {Auth.access_token}'}
