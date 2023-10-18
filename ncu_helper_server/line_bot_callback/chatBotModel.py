from .chatBotExtension import chat_status, jump_to, text, button_group, do_nothing
from typing import Tuple
from eeclass_setting.models import LineUser
from eeclass_setting.appModel import check_eeclass_update_pipeline, save_user_data, check_login_success, \
    find_account_password, find_user_by_use_id
import uuid
from django.core.cache import cache


@chat_status("default", default=True)
@button_group('EECLASS HELPER', '輸入以下指令開啟下一步', '輸入以下指令開啟下一步')
def default_message(event):
    jump_to(main_menu, event.source.user_id)
    return [
        'Notion Oauth連線',
        'EECLASS帳號設定',
        'EECLASS密碼設定',
        'EECLASS連線測試'
    ]


@chat_status("main menu")
@text
def main_menu(event):
    match event.message.text:
        case 'Notion Oauth連線':
            jump_to(oauth_connection, event.source.user_id, propagation=True)
            return
        case 'EECLASS帳號設定':
            jump_to(set_eeclass_account, event.source.user_id)
            return '請輸入你的EECLASS 帳號'
        case 'EECLASS密碼設定':
            jump_to(set_eeclass_password, event.source.user_id)
            return '請輸入你的EECLASS 密碼'
        case 'EECLASS連線測試':
            jump_to(eeclass_login_test, event.source.user_id, True)
            return
        case _:
            jump_to(default_message, event.source.user_id, True)
            return '沒有此項指令'


@chat_status("reply oauth link")
@text
def oauth_connection(event):
    state = str(uuid.uuid4())
    cache.set(state, event.source.user_id, timeout=300)
    u = f"https://www.notion.so/install-integration?response_type=code&client_id=5f8acc7a-6c3a-4344-b9e7-3c63a8fad01d&redirect_uri=https%3A%2F%2Fquan.squidspirit.com%2Fnotion%2Fredirect%2F&owner=user&state={state}"
    message = f"請透過連結登入 {u}"
    jump_to(default_message, event.source.user_id)
    return message


@chat_status("set eeclass account")
@text
def set_eeclass_account(event):
    try:
        save_user_data(event.source.user_id, account=event.message.text)
    except Exception as e:
        print(e)
    jump_to(default_message, event.source.user_id, True)
    return f'已更新你的帳號為 {event.message.text}'


@chat_status("set eeclass password")
@text
def set_eeclass_password(event):
    # TODO 設定密碼
    try:
        save_user_data(event.source.user_id, password=event.message.text)
    except Exception as e:
        print(e)
    jump_to(default_message, event.source.user_id, True)
    return f'已更新你的密碼為 {event.message.text}'


@chat_status("test eeclass login")
@text
def eeclass_login_test(event):
    jump_to(default_message, event.source.user_id)
    user_data, founded = find_account_password(event.source.user_id)
    if not founded:
        return '尚未設定帳號密碼'
    login_success = check_login_success(user_data['account'], user_data['password'])
    if login_success:
        return '帳號認證成功'
    else:
        return '帳號認證失敗，請重新設定帳號密碼'


@chat_status("eeclass update")
@text
def eeclass_update_test(event):
    jump_to(default_message, event.source.user_id, False)
    search_result:  Tuple[LineUser | None, bool] = find_user_by_use_id(event.source.user_id)
    user, founded = search_result
    if not founded:
        return '尚未設定帳號密碼'
    result = check_eeclass_update_pipeline(user)
    return result
