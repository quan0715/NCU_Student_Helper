from .chatBotExtension import chat_status, jump_to, text, button_group, do_nothing
from typing import Tuple
from eeclass_setting.models import LineUser
from eeclass_setting.appModel import check_eeclass_update_pipeline, check_login_success, \
    find_account_password, find_user_by_user_id
from django.core.cache import cache
from django.conf import settings
from .views import LineBotCallbackView as cb


@chat_status("default", default=True)
@button_group('EECLASS HELPER', '輸入以下指令開啟下一步', '輸入以下指令開啟下一步')
def default_message(event):
    jump_to(main_menu, event.source.user_id)
    return [
        '資料設定',
        'EECLASS更新'
    ]


@chat_status("main menu")
@text
def main_menu(event):
    match event.message.text:
        case '資料設定':
            jump_to(set_data, event.source.user_id, propagation=True)
            return settings.FRONT_END_WEB_URL
        case 'EECLASS更新':
            jump_to(update_eeclass, event.source.user_id, True)
            return
        case _:
            jump_to(default_message, event.source.user_id, True)
            return '沒有此項指令'



@chat_status("set_data")
@text
def set_data(event):
    jump_to(do_nothing, event.source.user_id)
    jump_to(default_message, event.source.user_id, True)
#


def update_eeclass(event):
    search_result:  Tuple[LineUser | None, bool] = find_user_by_user_id(event.source.user_id)
    user, founded = search_result
    if not founded:
        jump_to(default_message, event.source.user_id, True)
        return '尚未設定帳號密碼'
    cb.push_message(event.source.user_id, text(lambda ev: '獲取資料中')(event))
    try:
        result = check_eeclass_update_pipeline(user)
        print(result)
        jump_to(default_message, event.source.user_id, True)
        return result
    except Exception as e:
        jump_to(default_message, event.source.user_id, True)
        return f'獲取失敗, 錯誤訊息:\n{e}'
