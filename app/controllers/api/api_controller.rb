class Api::ApiController < Api::ApplicationController
  def fire
    @ship = ship
    @ship_to_shoot = Ship.find_by_name(params[:name])

    if @ship.fire!(@ship_to_shoot)
      render json: {
        state: @ship.as_json(only: ship_fields),
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
        begin
          client = ShipClient.new(@ship)
          client.scan(enemy)
        rescue;
        # TODO handle when we fail to update a ship
        end
      end
      render json: {
        ships: ships.as_json(only: ship_fields),
        sectors: sectors.as_json(only: [:name]),
        state: @ship.as_json(only: ship_fields)
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
    @ship = ship
    ship.charge
    sectors = Sector.where.not(id: @ship.sector.id)
      render json: {
        sectors: sectors.as_json(only: [:name]),
        state: @ship.as_json( :only => ship_fields )
      }
  end

  def travel
    @ship = ship
    sector = Sector.find_by_name(params[:sector])
    unless sector
      render nothing: true, status: 404
    end
    if @ship.travel!(sector)
      render :json => {
        :state => @ship.as_json(only: ship_fields),
      }
    else
      render nothing: true, status: 400
    end
  end

  private

  def ship_fields
    [:name, :image, :shield, :energy]
  end
end
