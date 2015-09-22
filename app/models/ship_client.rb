class ShipClient
  def initialize(ship)
    @ship = ship
  end

  def ping
    get('ping')
  end

  def hit
    get('hit')
  end

  private

  def get(path)
    HTTParty.get("#{ship_url}/#{path}")
  end

  def ship_url
    [@ship.source, @ship.port].join(":")
  end
end
