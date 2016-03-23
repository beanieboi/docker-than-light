class Api::ApplicationController < ActionController::Base
	skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :authenticate
  private

  def authenticate
    if authentication_token && ship
      unless ship.source.include? request.remote_ip
        render nothing: true, status: 404
      end
    end
  end

  def ship
    Ship.find_by!(token: authentication_token)
  end

  def authentication_token
  	unless request.headers.include?('Authorization')
      render nothing: true, status: 404
    end

    request.headers['Authorization']
  end

  def not_found
  	render nothing: true, status: 404
  end
end
