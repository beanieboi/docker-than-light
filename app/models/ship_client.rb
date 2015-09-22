class ShipClient
  def initialize(ship)
    @ship = ship
  end

  def ping
    options = {
      headers: headers
    }

    get('_ping', options)
  rescue Errno::ECONNREFUSED
  end

  def hit(enemy)
    options = {
      headers: headers,
      body: {
        "type": "hit",
        "state": @ship.to_json( :only => [:name, :shield, :energy]),
        "payload": {
          "damage": 10, "enemy":enemy.name
        }
      }
    }

    post('action', options)
  end

  def update
    options = {
      headers: headers,
      body: @ship.to_json( :only => [:name, :shield, :energy])
    }
    post('update', options)
  end

  def scan(enemy)
    options = {
      headers: headers,
      body: {
        "type": "scan",
        "state": @ship.to_json( :only => [:name, :shield, :energy]),
        "payload": {
          "enemy": enemy.name
        }
      }
    }

    post('action', options)
  end

  private

  def headers
    { "Authorization" => @ship.token }
  end

  def post(path, options)
    HTTParty.post("http://#{ship_url}/#{path}", options)
  end

  def get(path, options)
    HTTParty.get("http://#{ship_url}/#{path}", options)
  end

  def ship_url
    [@ship.source, @ship.port].join(":")
  end
end
