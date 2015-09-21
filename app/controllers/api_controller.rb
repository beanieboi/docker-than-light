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
    @ship_to_shot = Ship.find_by(source: params[:ip])
    @ship.fire!(@ship_to_shot)
  end

  def scan
    ship = Ship.first
    sectors = Sector.where("id not in (?)", ship.sector.id)
    ships = ship.sector.ships.where("id not in (?)", ship.id)
    render :json => {
      :ships => ships,
      :sectors => sectors,
      :state => ship,
    } 
  end

  def scan_ip
  end

  def upgrade
  end

  def sectors
  end

  def travel
    puts params
  end

  private

  def ship_params
    Ship.default_attributes.merge(name: params[:name], image: params[:image])
  end
end
