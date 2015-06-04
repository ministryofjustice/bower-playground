class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'erb/base'

  bowerrc_dir = JSON.parse(IO.read("#{Rails.root.to_s}/.bowerrc"))['directory']
  prepend_view_path(File.expand_path("#{Rails.root.to_s}/#{bowerrc_dir}/mojular/templates"))
end
