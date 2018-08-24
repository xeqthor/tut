from django.contrib.auth.views import LoginView as DjangoLoginView

from .forms import LoginForm


class LoginView(DjangoLoginView):
    template_name = 'finauth/login.html'
    form_class = LoginForm

    def form_valid(self, form):
        if not form.cleaned_data['remember_me']:
            self.request.session.set_expiry(0)
        return super().form_valid(form)