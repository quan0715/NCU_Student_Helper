import json
from typing import Dict, Tuple
from eeclass_setting.models import LineUser


def find_account_password(user_id: str) -> Tuple[Dict | None, bool]:
    """
    user_id: line_user_id\
    returned value: ({account, password}, founded)
    """
    if len(LineUser.objects.filter(line_user_id=user_id)) == 0:
        return None, False
    user = LineUser.objects.get(line_user_id=user_id)
    return {'account': user.eeclass_username, 'password': user.eeclass_password}, True

def find_user_by_user_id(user_id: str) -> Tuple[LineUser | None, bool]:
    """
    user_id: line_user_id\
    returned value: ({account, password}, founded)
    """
    if len(LineUser.objects.filter(line_user_id=user_id)) == 0:
        return None, False
    user = LineUser.objects.get(line_user_id=user_id)
    return user, True


import asyncio
from eeclass_setting.eeclass import eeclass_test_login, eeclass_pipeline


def check_login_success(account: str, password: str) -> bool:
    """
    account: eeclass account\
    password: eeclass password\
    returned value: login success
    """
    try:
        loop = asyncio.get_event_loop()
    except:
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
    try:
        task = loop.create_task(eeclass_test_login(account, password))
        loop.run_until_complete(task)
        login_success = task.result()
    except Exception as e:
        import traceback
        traceback.print_exc()
        return False
    return login_success


def check_eeclass_update_pipeline(user: LineUser) -> bool:
    """
    account: eeclass account\
    password: eeclass password\
    returned value: {content, success}
    """
    try:
        loop = asyncio.get_event_loop()
    except:
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
    task = loop.create_task(eeclass_pipeline(user))
    loop.run_until_complete(task)
    return task.result()


def save_user_data(user_id, account=None, password=None):
    """
    account: eeclass account
    password: eeclass password
    user_id: line_userid
    """
    try:
        user, created = LineUser.objects.get_or_create(line_user_id=user_id)
        if account:
            user.eeclass_username = account
        if password:
            user.eeclass_password = password
        user.save()
    except Exception as e:
        import traceback
        traceback.print_exc()


def get_oauth_data(user_id):
    """
    user_id: line_user_id\
    returned value: ({access_token, duplicated_template_id}, founded})
    """
    if len(LineUser.objects.filter(line_user_id=user_id)) == 0:
        return (None, False)
    user = LineUser.objects.get(line_user_id=user_id)
    return {'access_token': user.notion_token, 'duplicated_template_id': user.notion_template_id}, True
