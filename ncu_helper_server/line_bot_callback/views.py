from django.shortcuts import render

# Create your views here.
from django.conf import settings
from django.http import HttpResponse, HttpResponseBadRequest, HttpResponseForbidden
from django.views import View
from django.views.decorators.csrf import csrf_exempt

from linebot import LineBotApi, WebhookParser, WebhookHandler
from linebot.exceptions import InvalidSignatureError, LineBotApiError
from linebot.models import MessageEvent, TextSendMessage, FollowEvent
from concurrent.futures import ThreadPoolExecutor
# Create your views here.
from line_bot_callback.chatBotExtension import handle


class LineBotCallbackView(View):
    line_bot_api = LineBotApi(settings.LINE_CHANNEL_ACCESS_TOKEN)
    parser = WebhookParser(settings.LINE_CHANNEL_SECRET)
    handler = WebhookHandler(settings.LINE_CHANNEL_SECRET)
    # server_url = "https://api.squidspirit.com/ncuhelper"
    threadPoolExecutor = ThreadPoolExecutor()

    @csrf_exempt
    def dispatch(self, request, *args, **kwargs):
        return super(LineBotCallbackView, self).dispatch(request, *args, **kwargs)

    @csrf_exempt
    def post(self, request, *args, **kwargs):
        # this is necessary since otherwise function in chatBotModel will not be loaded
        import line_bot_callback.chatBotModel
        # you have to import this inside post method otherwise cycle import might happened
        signature = request.META['HTTP_X_LINE_SIGNATURE']
        body = request.body.decode('utf-8')

        try:
            events = self.parser.parse(body, signature)
        except InvalidSignatureError:
            return HttpResponseForbidden()
        except LineBotApiError:
            return HttpResponseBadRequest()

        for event in events:
            if isinstance(event, (MessageEvent, FollowEvent)):
                self.message_handler(event)

        return HttpResponse()

    @handler.add(MessageEvent, message=TextSendMessage)
    def message_handler(self, event):
        def reply(event):
            replies = handle(event)
            self.line_bot_api.reply_message(event.reply_token, replies)
            # from chatBotExtension import jump_to
            # from chatBotModel import default_message
            # jump_to(default_message, event.source.user_id, False)

        self.threadPoolExecutor.submit(reply, event)

    @classmethod
    def push_message(cls, user_id, messages):
        cls.line_bot_api.push_message(user_id, messages)
