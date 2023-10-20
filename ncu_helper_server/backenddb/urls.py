from django.urls import path
from .views import *

urlpatterns = [
    path('HSR/get_data', get_hsr_data),  # Redirect URI
    path('HSR/save_data', save_hsr_data)
]