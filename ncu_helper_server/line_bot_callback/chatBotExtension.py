from .models import ChatStatus

__statuses:dict[str, callable]={}
__default_status:str|None=None
__invert_status_map:[callable, str]={}

from linebot.models import TextSendMessage, TemplateSendMessage, ButtonsTemplate, MessageAction

def chat_status(status_id:str, default=False):
    """
    use this as the decorator when you want your function to be a status of a chat bot.\
    status_id: unique id for the state, can be used for debugging
    default: set default state, first decorated is default if no function assigned
    """
    def wrapper(func):
        __statuses[status_id]=func
        __invert_status_map[func]=status_id
        global __default_status
        if default or __default_status is None: 
            __default_status=status_id
        return func
    return wrapper

def text(func):
    """
    wrap a function returning a string as legal chatBot returned message
    """
    def wrapper(event):
        text = func(event)
        return TextSendMessage(text) if text else None
    return wrapper

def button_group(title="", text="", default_text='default alt text'):
    """
    wrap a function returning a list of string as the button group text of chatbot
    title: title of the button group
    text: text of the button group
    default_text: text showed outside chat room
    """
    def outer(func):
        def wrapper(event):
            button_texts = func(event)
            if not button_texts: return None
            actions = [MessageAction(text, text) for text in button_texts]
            return TemplateSendMessage(
                alt_text=default_text,
                template=ButtonsTemplate(
                    title=title,
                    text=text,
                    actions=actions
                )
            )
        return wrapper
    return outer

def handle(event)->list:
    """
    return the result of the state flow
    event: line chatbot event
    """
    assert __default_status is not None
    try:
        user_id = event.source.user_id
        status_exists = ChatStatus.objects.filter(line_user_id=user_id)
        if not status_exists:
            chat_status = ChatStatus(line_user_id=user_id, status=__default_status)
            chat_status.save()

        replies = []
        while True:
            status = ChatStatus.objects.get(line_user_id=user_id).status
            print(status)
            reply = __statuses.get(status, __statuses[__default_status])(event)
            if reply: replies.append(reply)
            if not ChatStatus.objects.get(line_user_id=user_id).propagation:
                break
        print(ChatStatus.objects.get(line_user_id=user_id).status)
        return replies
    except Exception as e:
        print(e)


def jump_to(func:callable, user_id, propagation=False):
    """
    link current status to next status, next status will be execute after current status return
    func: status function you want to transfer to
    user_id: line chatbot user_id
    propagation: if set to True, transfer to the status with current event as input
    """
    try:
        status_exists = ChatStatus.objects.filter(line_user_id=user_id)
        if not status_exists:
            chat_status = ChatStatus(line_user_id=user_id)
        else:
            chat_status = ChatStatus.objects.get(line_user_id=user_id)
        chat_status.status = __invert_status_map[func]
        chat_status.propagation = propagation
        chat_status.save()

    except Exception as e:
        print(e)