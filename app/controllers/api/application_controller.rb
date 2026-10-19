class Api::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :authenticate
  private

  def authenticate
    if authentication_token && ship
      unless ship.source.include? request.remote_ip
        head :not_found
      end
    end
  end

  def ship
    Ship.find_by!(token: authentication_token)
  end

  def authentication_token
  	unless request.headers.include?('Authorization')
      head :not_found
    end

    request.headers['Authorization']
  end

  def not_found
  	head :not_found
  end
end
