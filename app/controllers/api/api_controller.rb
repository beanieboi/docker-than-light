class Api::ApiController < Api::ApplicationController
  def spawn
    ship = Ship.new(ship_params)

    if ship.save
      ship.spawn
      redirect_to ship_log_path(ship.name)
    else
      redirect_to :back, alert: "Ship could not be spawned"
    end
  end

  def fire
    @ship = ship
    @ship_to_shoot = Ship.find_by_name(params[:name])

    if @ship.fire!(@ship_to_shoot)
      render json: {
        state: @ship,
      }
    else
      render nothing: true, status: 400
    end
  end

  def scan
    @ship = ship
    if @ship.scan! && @ship.sector
      sectors = Sector.where.not(id: @ship.sector.id)
      ships = @ship.sector.ships.where.not(id: @ship.id)
      ships.each do |enemy|
        client = ShipClient.new(@ship)
        client.scan(enemy)
      end

      render json: {
        ships: ships,
        sectors: sectors,
        state: @ship,
      }
    else
      render nothing: true, status: 400
    end
  end

  def scan_ship
  end

  def upgrade
  end

  def sectors
  end

  def travel
    @ship = ship
    sector = Sector.find_by_name(params[:sector])
    unless sector
      render nothing: true, status: 404
    end
    if @ship.travel!(sector)
      render :json => {
        :state => @ship,
      }
    else
      render nothing: true, status: 400
    end
  end

  private

  def ship_params
    Ship.default_attributes.merge(name: params[:name], image: params[:image])
  end
end
