import json
from typing import Dict, Tuple
from .models import LineUser
def find_account_password(user_id:str)->Tuple[Dict | None, bool]:
    """
    user_id: line_user_id\
    returned value: ({account, password}, founded)
    """
    if len(LineUser.objects.filter(line_user_id=user_id))==0:
        return (None, False)
    user = LineUser.objects.get(line_user_id=user_id)
    return ({'account':user.eeclass_username, 'password':user.eeclass_password}, True)

    
import asyncio
from eeclass_setting.eeclass import eeclass_test_login
def check_login_success(account:str, password:str)->bool:
    """
    account: eeclass account\
    password: eeclass password\
    returned value: login success
    """
    try:
        loop = asyncio.get_event_loop()
    except:
        loop=asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
    try:
        task = loop.create_task(eeclass_test_login(account, password))
        loop.run_until_complete(task)
        login_success = task.result()
    except Exception as e:
        print(e)
    return login_success

def save_user_data(user_id, account=None, password=None):
    """
    account: eeclass account
    password: eeclass password
    user_id: line_userid
    """
    try:
        user, created = LineUser.objects.get_or_create(line_user_id=user_id)
<<<<<<< HEAD
=======
        print(user, account, password, created)
>>>>>>> b9dd81e (first)
        if account:
            user.eeclass_username=account
        if password:
            user.eeclass_password=password
        user.save()
    except Exception as e:
        print(e)