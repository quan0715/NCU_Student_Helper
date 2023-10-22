import json
from django.shortcuts import render

# Create your views here.
from django.conf import settings
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from . import appModel
from fastapi import status

@csrf_exempt
def get_hsr_data(request, *args, **kwargs):
    if request.method != 'GET':
        return HttpResponse(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    user, founded = appModel.find_hsr_data(request.GET.get('user_id'))
    if not founded:
        return HttpResponse(status=status.HTTP_404_NOT_FOUND)
    return JsonResponse({
        "id_card_number":user.id_card_number,
        "phone_number":user.phone_number,
        "email":user.email,
    })

@csrf_exempt
def save_hsr_data(request, *args, **kwargs):
    try:
        body = json.loads(request.body.decode('utf-8'))
        appModel.save_hsr_data(body['user_id'], body['id_card_number'], body['phone_number'], body['email'])
        return HttpResponse(status=status.HTTP_200_OK)
    except Exception as e:
        import traceback
        traceback.print_exc()
    return HttpResponse(status=status.HTTP_401_UNAUTHORIZED)