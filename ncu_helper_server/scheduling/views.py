import json
from django.shortcuts import render

# Create your views here.
from django.conf import settings
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from scheduling.appModel import find_auto_scheduling, save_user_data, update_schedule
from fastapi import status
# Create your views here.


@csrf_exempt
def get_data(request, *args, **kwargs):
    if request.method!='GET':
        return HttpResponse(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    data, founded = find_auto_scheduling(request.GET.get('user_id'))
    if not founded:
        return HttpResponse(status=status.HTTP_404_NOT_FOUND)
    return JsonResponse(data)

@csrf_exempt
def update_scheduling(request, *args, **kwargs):
    try:
        body = json.loads(request.body.decode('utf-8'))
        if update_schedule(body['user_id'], body['scheduling_time'], body['is_auto_update']):
            if not save_user_data(body['user_id'], body['scheduling_time'], body['is_auto_update']):
                return HttpResponse(status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            return HttpResponse(status=status.HTTP_200_OK)
    except Exception as e:
        import traceback
        traceback.print_exc()
    return HttpResponse(status=status.HTTP_401_UNAUTHORIZED)
