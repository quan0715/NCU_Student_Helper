from .chatBotExtension import chat_status, jump_to, text, button_group, do_nothing, state_ai_agent
from typing import Tuple
from eeclass_setting.models import LineUser
from eeclass_setting.appModel import check_eeclass_update_pipeline, find_user_by_user_id
from django.core.cache import cache
from django.conf import settings
from .views import LineBotCallbackView as cb
from .langChainAgent import LangChainAgent


@chat_status("default", default=True)
@button_group('EECLASS HELPER', '輸入以下指令開啟下一步', '輸入以下指令開啟下一步')
def default_message(event):
    jump_to(main_menu, event.source.user_id)
    return [
        '資料設定',
        'EECLASS查詢',
        '交通查詢'
    ]

@chat_status("main menu")
@text
@state_ai_agent(LangChainAgent())
# replace LangChainAgent by any agent you want to use
def main_menu(event, aiAgent: LangChainAgent):
    # aiAgent equal to parameter in @state_ai_agent
    match event.message.text:
        case '資料設定':
            jump_to(default_message, event.source.user_id, propagation=True)
            return settings.FRONT_END_WEB_URL
        case 'EECLASS查詢':
            jump_to(update_eeclass, event.source.user_id, True)
            return
        case '交通查詢':
            jump_to(traffic_message, event.source.user_id, True)
            return
        case _:
            jump_to(do_nothing, event.source.user_id)
            try:
                msg = aiAgent.run(event.message.text)
                jump_to(default_message, event.source.user_id, True)
                # if you update aiAgent and method changed, update code here
                return msg
            except:
                import traceback
                traceback.print_exc()
                jump_to(default_message, event.source.user_id, True)
                return 'error occur by chatbot ai'

@chat_status("traffic message")
@button_group("通勤項目", "請選擇通勤項目", "通勤項目選單")
def traffic_message(event):
    jump_to(traffic_menu, event.source.user_id)
    return [
        '公車查詢',
        '高鐵查詢/訂票',
        '返回'
    ]

@chat_status("traffic_menu")
@text
def traffic_menu(event):
    match event.message.text:
        case '公車查詢':
            jump_to(bus_util, event.source.user_id, False)
            return "請問你想要查什麼公車呢？"
        case '高鐵查詢/訂票':
            jump_to(hsr_util, event.source.user_id, False)
            return "請問您想要訂哪一天什麼時間的高鐵票呢？"
        case '返回':
            jump_to(default_message, event.source.user_id, True)
            return
        case _:
            return '無此指令'

@chat_status("update eeclass")
@text
def update_eeclass(event):
    search_result:  Tuple[LineUser | None,
                          bool] = find_user_by_user_id(event.source.user_id)
    user, founded = search_result
    if not founded:
        jump_to(default_message, event.source.user_id, True)
        return '尚未設定帳號密碼'
    cb.push_message(event.source.user_id, text(lambda ev: '獲取資料中')(event))
    try:
        result = check_eeclass_update_pipeline(user)
        jump_to(eeclass_util, event.source.user_id, True)
        return result
    except Exception as e:
        jump_to(default_message, event.source.user_id, True)
        return f'獲取失敗, 錯誤訊息:\n{e}'


@chat_status("hsr util")
@text
def hsr_util(event):
    from . import hsrChatbot
    hsr_agent_pool_instance = hsrChatbot.get_agent_pool_instance()
    agent = hsr_agent_pool_instance.get(event.source.user_id)
    if agent is None:
        agent = hsr_agent_pool_instance.add(event.source.user_id)
        agent.run("我要訂高鐵票")
    return agent.run(event.message.text)


@chat_status("eeclass util")
@text
def eeclass_util(event):
    # from . import eeclassChatbot
    # eeclass_agent_pool_instance = eeclassChatbot.get_agent_pool_instance()
    # agent = eeclass_agent_pool_instance.get(event.source.user_id)
    # if agent is None:
    #     agent = eeclass_agent_pool_instance.add(event.source.user_id)
    #     agent.run("我要知道eeclass更新了啥")
    # return agent.run(event.message.text)
    jump_to(default_message, event.source.user_id, True)
    return '請實作eeclassChatBot'

@chat_status("bus util")
@text
def bus_util(event):
    # from . import busChatbot
    # bus_agent_pool_instance = busChatbot.get_agent_pool_instance()
    # agent = bus_agent_pool_instance.get(event.source.user_id)
    # if agent is None:
    #     agent = bus_agent_pool_instance.add(event.source.user_id)
    #     agent.run("我要查詢公車")
    # return agent.run(event.message.text)
    jump_to(traffic_message, event.source.user_id, True)
    return '請實作busChatbot功能'
