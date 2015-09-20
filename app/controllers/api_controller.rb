class ApiController < ApplicationController

  def spawn
    ship = Ship.new(ship_params)

    if ship.save
      redirect_to ship_log_path(ship.name)
    else
      redirect_to :back, alert: "Ship could not be spawned"
    end
  end

  def fire
    @ship = Ship.find_by!(source: request.ip)
    @ship.fire!
  end

  def scan
  end

  def scan_ip
  end

  def upgrade
  end

  def sectors
  end

  def travel
  end

  private

  def ship_params
    Ship.default_attributes.merge(name: params[:name], image: params[:image])
  end
end
