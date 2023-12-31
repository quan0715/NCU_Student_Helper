import json
from django.shortcuts import render

# Create your views here.
from django.conf import settings
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from eeclass_setting.appModel import get_oauth_data, find_account_password, check_login_success, save_user_data, find_user_by_user_id
from fastapi import status
# Create your views here.

@csrf_exempt
def check_login(request, *args, **kwargs):
    try:
        body = json.loads(request.body.decode('utf-8'))
        if check_login_success(body['account'], body['password']):
            save_user_data(body['user_id'], body['account'], body['password'])
            return HttpResponse(status=status.HTTP_200_OK)
    except Exception as e:
        import traceback
        traceback.print_exc()
    return HttpResponse(status=status.HTTP_401_UNAUTHORIZED)

@csrf_exempt
def get_notion_oauth_data(request, *args, **kwargs):
    if request.method != 'GET':
        return HttpResponse(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    data, founded = get_oauth_data(request.GET.get('user_id'))
    if not founded:
        return HttpResponse(status=status.HTTP_404_NOT_FOUND)
    return JsonResponse(data)

@csrf_exempt
def get_account_password(request, *args, **kwargs):
    if request.method != 'GET':
        return HttpResponse(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    data, founded = find_account_password(request.GET.get('user_id'))
    if not founded:
        return HttpResponse(status=status.HTTP_404_NOT_FOUND)
    return JsonResponse(data)

@csrf_exempt
def get_data(request, *args, **kwargs):
    if request.method != 'GET':
        return HttpResponse(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    user, founded = find_user_by_user_id(request.GET.get('user_id'))
    if not founded:
        return HttpResponse(status=status.HTTP_404_NOT_FOUND)
    return JsonResponse({
        "eeclass_account":user.eeclass_username,
        "eeclass_password":user.eeclass_password,
        "notion_token":user.notion_token,
        "notion_template_id":user.notion_template_id,
    })

@csrf_exempt
def check_connection(request):
    return HttpResponse(status=status.HTTP_200_OK)