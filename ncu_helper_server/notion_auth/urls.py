from django.urls import path
from .views import *

urlpatterns = [
    # path('', notion_auth_start, name='notion_auth_start'),
    path('redirect', notion_auth_callback, name="notion_auth_callback"),  # Redirect URI
    path('auth', notion_auth_start, name='notion_auth_start'),
]