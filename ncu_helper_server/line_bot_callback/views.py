from django.shortcuts import render

# Create your views here.
from django.conf import settings
from django.http import HttpResponse, HttpResponseBadRequest, HttpResponseForbidden
from django.views import View
from django.views.decorators.csrf import csrf_exempt

from linebot import LineBotApi, WebhookParser, WebhookHandler
from linebot.exceptions import InvalidSignatureError, LineBotApiError
from linebot.models import MessageEvent, TextSendMessage
from concurrent.futures import ThreadPoolExecutor
# Create your views here.

import line_bot_callback.chatBotModel
from line_bot_callback.chatBotExtension import handle


class LineBotCallbackView(View):
    line_bot_api = LineBotApi(settings.LINE_CHANNEL_ACCESS_TOKEN)
    parser = WebhookParser(settings.LINE_CHANNEL_SECRET)
    handler = WebhookHandler(settings.LINE_CHANNEL_SECRET)
    # server_url = "https://quan.squidspirit.com"
    threadPoolExecutor = ThreadPoolExecutor()

    @csrf_exempt
    def dispatch(self, request, *args, **kwargs):
        return super(LineBotCallbackView, self).dispatch(request, *args, **kwargs)

    @csrf_exempt
    def post(self, request, *args, **kwargs):
        # if request.method == 'POST':
        signature = request.META['HTTP_X_LINE_SIGNATURE']
        body = request.body.decode('utf-8')

        try:
            events = self.parser.parse(body, signature)
        except InvalidSignatureError:
            return HttpResponseForbidden()
        except LineBotApiError:
            return HttpResponseBadRequest()

        for event in events:
            if isinstance(event, MessageEvent):
                self.message_handler(event)

        return HttpResponse()

    @handler.add(MessageEvent, message=TextSendMessage)
    def message_handler(self, event):
        print(event.source.user_id)
        def reply(event):
            replies=handle(event)
            for idx, reply in enumerate(replies):
                if idx==len(replies)-1: break
                self.line_bot_api.push_message(event.source.user_id, reply)
            if len(replies):
                self.line_bot_api.reply_message(event.reply_token, replies[-1])

        self.threadPoolExecutor.submit(reply, event)

    # @classmethod
    # def notion_auth_callback(cls, user_id):
    #     class fake_source:
    #         def __init__(self, user_id):
    #             self.user_id=user_id
    #
    #     class fake_event:
    #         def __init__(self, user_id):
    #             self.source=fake_source(user_id)
    #
    #     cls.line_bot_api.push_message(user_id, TextSendMessage(text="與Notion連線成功"))
    #     from .chatBotModel import default_message
    #     cls.line_bot_api.push_message(user_id, default_message(fake_event(user_id)))

