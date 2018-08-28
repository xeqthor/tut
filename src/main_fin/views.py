from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render
from django.views.generic import TemplateView

import xlrd


class MainView(LoginRequiredMixin, TemplateView):
    template_name = 'main_fin/index.html'

    def post(self, request):
        excel_data = []
        excel_file = self.request.FILES.get("excel_file")
        if excel_file:
            wb = xlrd.open_workbook(f'{excel_file}')
            ws = wb.sheet_by_index(0)
            for row in range(ws.nrows):
                row_data = []
                for col in range(ws.ncols):
                    row_data.append(str(ws.cell_value(row, col)))
                excel_data.append(row_data)
        return render(request, 'main_fin/index.html', {"excel_data": excel_data})
