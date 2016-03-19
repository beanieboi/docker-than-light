class Website::ApplicationController < ActionController::Base
  include AuthenticatedSystem

  protect_from_forgery with: :exception

  layout 'application'
end
