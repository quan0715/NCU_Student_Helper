import json
from typing import Dict, Tuple
from .models import SchedulingData


def find_auto_scheduling(user_id: str) -> Tuple[Dict | None, bool]:
    """
    user_id: line_user_id\
    returned value: ({is_auto_update, scheduling_time}, founded)
    """
    if len(SchedulingData.objects.filter(line_user_id=user_id)) == 0:
        return None, False
    user = SchedulingData.objects.get(line_user_id=user_id)
    return {'is_auto_update': user.is_auto_update, 'scheduling_time': user.scheduling_time}, True

def update_schedule(user_id:str, interval: int):
    # TODO update scheduling
    return True

def save_user_data(user_id:str, interval: int=None, is_auto_scheduling:bool=None):
    try:
        user, created = SchedulingData.objects.get_or_create(line_user_id=user_id)
        if is_auto_scheduling:
            user.is_auto_scheduling = is_auto_scheduling
        if interval:
            user.interval = interval
        user.save()
    except Exception as e:
        print(e)