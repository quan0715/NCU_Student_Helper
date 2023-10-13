from .models import ChatStatus

__statuses:dict[str, callable]={}
__default_status:str|None=None
__invert_status_map:[callable, str]={}

from linebot.models import TextSendMessage, TemplateSendMessage, ButtonsTemplate, MessageAction

def chat_status(status_id:str, default=False):
    """
    use this as the decorator
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
    def wrapper(event):
        text = func(event)
        return TextSendMessage(text) if text else None
    return wrapper

def button_group(title="", text="", default_text='default alt text'):
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

def handle(event):
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