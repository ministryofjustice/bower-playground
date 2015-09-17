class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout "erb/external"
  prepend_view_path(File.expand_path("#{Mojular::Rails::Engine.root}/templates"))
end
