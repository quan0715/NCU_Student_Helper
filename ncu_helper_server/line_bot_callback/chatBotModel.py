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
        'EECLASS更新'
    ]


@chat_status("main menu")
@text
@state_ai_agent(LangChainAgent())
def main_menu(event, aiAgent:LangChainAgent):
    match event.message.text:
        case '資料設定':
            jump_to(set_data, event.source.user_id, propagation=True)
            return settings.FRONT_END_WEB_URL
        case 'EECLASS更新':
            jump_to(update_eeclass, event.source.user_id, True)
            return
        case _:
            jump_to(do_nothing, event.source.user_id)
            try:
                msg = aiAgent.run(event.message.text)
                jump_to(default_message, event.source.user_id, True)
                return msg
            except:
                import traceback
                traceback.print_exc()
                jump_to(default_message, event.source.user_id, True)
                return 'error occur by chatbot ai'




@chat_status("langchain")
@text
def langchain(event):
    llm = ChatOpenAI(model="gpt-3.5-turbo-0613", openai_api_key=settings.OPEN_AI_API_KEY)
    print(event.message.text)
    prompt = ChatPromptTemplate.from_template("你是一個中央大學的AI學生助理，專門幫助學生解決各種疑難雜症，以下需要你幫忙解決關於 {topic} 的疑問")
    chain = prompt | llm
    results = chain.invoke({"topic": event.message.text})
    print(results.content)

    jump_to(main_menu, event.source.user_id, False)
    return results.content


@chat_status("set_data")
@text
def set_data(event):
    jump_to(do_nothing, event.source.user_id)
    jump_to(default_message, event.source.user_id, True)
#

@chat_status("update eeclass")
@text
def update_eeclass(event):
    print('update_eeclass')
    search_result:  Tuple[LineUser | None, bool] = find_user_by_user_id(event.source.user_id)
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
