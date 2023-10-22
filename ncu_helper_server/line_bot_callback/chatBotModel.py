from .ncu_wiki import getWikiChainLLM
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
        'EECLASS更新',
        '交通查詢',
        'EECLASS查詢'
    ]


@chat_status("main menu")
@text
@state_ai_agent(getWikiChainLLM())
# replace LangChainAgent by any agent you want to use
def main_menu(event, aiAgent):
    # aiAgent equal to parameter in @state_ai_agent
    match event.message.text:
        case '資料設定':
            jump_to(default_message, event.source.user_id, propagation=True)
            return settings.FRONT_END_WEB_URL
        case 'EECLASS更新':
            jump_to(update_eeclass, event.source.user_id, True)
            return
        case '交通查詢':
            jump_to(traffic_message, event.source.user_id, True)
            return
        case 'EECLASS查詢':
            jump_to(ee_query_message, event.source.user_id, True)
        case _:
            jump_to(do_nothing, event.source.user_id)
            try:
                msg = aiAgent(event.message.text)['result']
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
            from backenddb.appModel import find_hsr_data
            hsr_data, founded = find_hsr_data(event.source.user_id)
            warning_msg = "" if founded else "（您還沒設定高鐵訂票所需的個人資訊喔！）"
            return "請問您想要訂哪一天什麼時間的高鐵票呢？" + warning_msg
        case '返回':
            jump_to(default_message, event.source.user_id, True)
            return
        case _:
            return '無此指令'


@chat_status("update eeclass")
@text
def update_eeclass(event):
    print('update_eeclass')
    search_result:  Tuple[LineUser | None,
                          bool] = find_user_by_user_id(event.source.user_id)
    user, founded = search_result
    if not founded:
        jump_to(default_message, event.source.user_id, True)
        return '尚未設定帳號密碼'
    cb.push_message(event.source.user_id, text(lambda ev: '獲取資料中')(event))
    try:
        result = check_eeclass_update_pipeline(user)
        jump_to(default_message, event.source.user_id, True)
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


@chat_status("bus util")
@text
def bus_util(event):
    from . import busChatbot
    bus_agent_pool_instance = busChatbot.get_agent_pool_instance()
    agent = bus_agent_pool_instance.get(event.source.user_id)
    if agent is None:
        agent = bus_agent_pool_instance.add(event.source.user_id)
        agent.run("我要查詢公車")
    return agent.run(event.message.text)

@chat_status("ee_query_message")
@button_group("EECLASS查詢項目", "請選擇要查詢的項目", "項目選單")
def ee_query_message(event):
    jump_to(kind_menu, event.source.user_id)
    return [
        '課程',
        '作業',
        '公告',
        '教材'
    ]

@chat_status("kind_menu")
@text
def kind_menu(event):
    match event.message.text:
        case '課程':
            jump_to(about_course, event.source.user_id, False)
            return "請問你想要查什麼哪門課程呢？"
        case '作業' | '公告' | '教材':
            jump_to(about_course, event.source.user_id, False)
            return f"請問您想要查詢關於哪一門課程相關的{event.message.text}呢？"
        case '返回':
            jump_to(default_message, event.source.user_id, True)
            return
        case _:
            return '無此指令'

@chat_status("about_kind")
@text
def about_course(event):
    from . import eeclassBotTool
    ee_agent_pool_instance = eeclassBotTool.get_agent_pool_instance()
    agent = ee_agent_pool_instance.get(event.source.user_id)
    if agent is None:
        agent = ee_agent_pool_instance.add(event.source.user_id)
        agent.run("我要查詢EECLASS資料")
    return agent.run(event.message.text)