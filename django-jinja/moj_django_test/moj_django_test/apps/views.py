from django.views.generic import TemplateView

class HomeView(TemplateView):
	template_name = 'home.html'

	def get(self, request, *args, **kwargs):
		context = {
			'dynbamic': 'Dynamic value here',
		}
		return self.render_to_response(context)
