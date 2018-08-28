
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('', include('main_fin.urls')),
    path('', include('finauth.urls')),
    path('admin/', admin.site.urls),
]
