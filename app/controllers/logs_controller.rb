class LogsController < ApplicationController
  def show
    @ship = Ship.find_by!(name: params[:ship_name])
  end
end
