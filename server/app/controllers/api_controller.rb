class ApiController < ApplicationController

  def spawn
    ship = Ship.new(ship_params)

    if ship.save
      redirect_to :back
    end
  end

  def fire
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
