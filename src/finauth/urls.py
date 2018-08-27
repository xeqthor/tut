from django.contrib.auth.views import LogoutView
from django.urls import path

from . import views

app_name = 'finauth'

urlpatterns = [
    path('login/', views.LoginView.as_view(), name='login'),
    path('register/', views.RegistrationView.as_view(), name='register'),
    path('logout/', LogoutView.as_view(), name='logout'),
]
