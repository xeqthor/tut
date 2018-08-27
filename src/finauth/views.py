from django.contrib.auth.views import LoginView as DjangoLoginView
from django.views.generic import CreateView

from .forms import LoginForm, RegisterForm


class LoginView(DjangoLoginView):
    template_name = 'finauth/login.html'
    form_class = LoginForm

    def form_valid(self, form):
        if not form.cleaned_data['remember_me']:
            self.request.session.set_expiry(0)
        return super().form_valid(form)


class RegistrationView(CreateView):
    template_name = 'finauth/register.html'
    form_class = RegisterForm
    success_url = '/'
