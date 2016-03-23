class Application::ShipsController < ApplicationController
  def create
    ship = Ship.new(ship_params)

    if ship.save
      ship.spawn
      redirect_to ship_log_path(ship.name)
    else
      redirect_to :back, alert: "Ship could not be spawned"
    end
  end

  private

  def ship_params
    Ship.default_attributes.merge(name: params[:name], image: params[:image])
  end
end
