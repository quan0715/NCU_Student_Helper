import json
from django.shortcuts import render, redirect
from django.http import HttpRequest, HttpResponse
from django.views import View
import requests as re
from oauthlib.oauth2 import WebApplicationClient

from line_bot_callback.views import *
from notion_auth.apps import NotionAuthConfig
from django.core import cache
from django.conf import settings
from requests.auth import HTTPBasicAuth
from eeclass_setting.models import LineUser
import base64
# Create your views here.

# server_url = 'quan.squidspirit.com'  # The URL of this server
# redirect_uri = f"https://{server_url}/notion/redirect/"
import os 
os.environ['OAUTHLIB_INSECURE_TRANSPORT'] = '1'

@csrf_exempt
def notion_auth_start(request):
    # client_id = settings.NOTION_OAUTH_CLIENT_ID
    line_use_id = request.GET.get('user_id')
    print(line_use_id)
    NOTION_OAUTH_CLIENT_ID= settings.NOTION_OAUTH_CLIENT_ID
    print(NOTION_OAUTH_CLIENT_ID)
    # NOTION_OAUTH_SECRET_KEY="secret_oAy3uqO45KRMjxqerfuq00UWsR5meRW88yCmYgxaWyq"
    REDIRECT_URI = settings.SERVER + "/notion/redirect"
    AUTH_ENDPOINT = "https://api.notion.com/v1/oauth/authorize"
    client = WebApplicationClient(NOTION_OAUTH_CLIENT_ID)
    require_url = client.prepare_request_uri(AUTH_ENDPOINT, redirect_uri=REDIRECT_URI, state=line_use_id)
    return redirect(require_url)
  
def notion_auth_callback(request):
    url = request.get_full_path()
    NOTION_OAUTH_CLIENT_ID= settings.NOTION_OAUTH_CLIENT_ID
    NOTION_OAUTH_SECRET_KEY= settings.NOTION_OAUTH_SECRET_KEY
    GET_TOKEN_ENDPOINT = 'https://api.notion.com/v1/oauth/token'
    REDIRECT_URI = settings.SERVER + "/notion/redirect"
    auth = HTTPBasicAuth(NOTION_OAUTH_CLIENT_ID, NOTION_OAUTH_SECRET_KEY)
    client = WebApplicationClient(NOTION_OAUTH_CLIENT_ID)
    try:
        code = request.GET.get('code')
        line_use_id = request.GET.get('state')
        print(line_use_id)
        # code = client.parse_request_uri_response(settings.SERVER + url)  # Extracts the code from the url
        token_request_params = client.prepare_token_request(GET_TOKEN_ENDPOINT, url, REDIRECT_URI)
        response = re.post(token_request_params[0], headers=token_request_params[1], data=token_request_params[2], auth=auth)
        data = response.json()
        print(data)
        access_token = data['access_token']
        duplicated_template_id = data['duplicated_template_id']
        
        user, create = LineUser.objects.get_or_create(line_user_id=line_use_id)
        
        user.notion_token = access_token
        user.eeclass_db_id = duplicated_template_id
        user.save()
        
    except Exception as e:
        print(e)
        return HttpResponse('<div>something wrong QQQ</div>')
    
    return redirect(settings.SERVER)

