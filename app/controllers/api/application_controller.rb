class Api::ApplicationController < ApplicationController
	skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

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
