from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.views import LoginView as DjangoLoginView
from django.views.generic import CreateView

from .forms import LoginForm


class LoginView(DjangoLoginView):
    template_name = 'finauth/login.html'
    form_class = LoginForm

    def form_valid(self, form):
        if not form.cleaned_data['remember_me']:
            self.request.session.set_expiry(0)
        return super().form_valid(form)


class RegistrationView(CreateView):
    template_name = 'registration/register.html'
    form_class = UserCreationForm
    success_url = 'main:index'
