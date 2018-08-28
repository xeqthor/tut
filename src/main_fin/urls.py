from django.urls import path

from . import views

app_name = 'main_fin'

urlpatterns = [
    path('', views.MainView.as_view(), name='index'),
]
