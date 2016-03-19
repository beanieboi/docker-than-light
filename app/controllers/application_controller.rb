class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  protect_from_forgery with: :exception

  before_action :login_required
end
