import json
from typing import Dict, Tuple
from .models import SchedulingData
from .scheduler import get_scheduler


def find_auto_scheduling(user_id: str) -> Tuple[Dict | None, bool]:
    """
    user_id: line_user_id\
    returned value: ({is_auto_update, scheduling_time}, founded)
    """
    if len(SchedulingData.objects.filter(line_user_id=user_id)) == 0:
        return None, False
    user = SchedulingData.objects.get(line_user_id=user_id)
    return {'is_auto_update': user.is_auto_update, 'scheduling_time': user.scheduling_time // 60}, True


def get_scheduling_task(user_id: str):
    from line_bot_callback.chatBotExtension import text
    from line_bot_callback.views import LineBotCallbackView as cb
    from eeclass_setting.models import LineUser
    from eeclass_setting.appModel import find_user_by_user_id, check_eeclass_update_pipeline
    def scheduling_task():
        try:
            search_result: Tuple[LineUser | None, bool] = find_user_by_user_id(user_id)
            user, founded = search_result
            if not founded:
                cb.push_message(user_id, text(lambda ev: '尚未設定帳號密碼')(0))
                return
            cb.push_message(user_id, text(lambda ev: '獲取資料中')(0))
            result = check_eeclass_update_pipeline(user)
            cb.push_message(user_id, text(lambda ev: result)(0))
        except Exception as e:
            cb.push_message(user_id, text(lambda ev: f'獲取失敗')(0))

    return scheduling_task


def update_schedule(user_id: str, interval: int, is_auto_scheduling: bool):
    """
    interval: minute
    """
    try:
        scheduler = get_scheduler()
        if not is_auto_scheduling:
            scheduler.remove_job(user_id, None)
            return True
        scheduler.add_or_reschedule_job(user_id, get_scheduling_task(user_id), interval * 60)
        return True
    except Exception:
        import traceback
        traceback.print_exc()
        return False


def save_user_data(user_id: str, scheduling_time: int = None, is_auto_update: bool = None):
    """
    scheduling_time: minute
    """
    try:
        user, created = SchedulingData.objects.get_or_create(line_user_id=user_id)
        if is_auto_update is not None:
            user.is_auto_update = is_auto_update
        if scheduling_time is not None:
            user.scheduling_time = scheduling_time * 60
        user.save()
        return True
    except Exception as e:
        return False


def init_scheduler_tasks_from_db():
    from .models import SchedulingData
    scheduler = get_scheduler()
    for schedulingData in SchedulingData.objects.all():
        if schedulingData.is_auto_update:
            scheduler.add_or_reschedule_job(
                schedulingData.line_user_id,
                get_scheduling_task(schedulingData.line_user_id),
                schedulingData.scheduling_time
            )
