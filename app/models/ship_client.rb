class ShipClient
  def initialize(ship)
    @ship = ship
  end

  def ping
    get('ping')
  end

  def hit
    options = {
      body: {
        "type": "hit",
        "state": {
          "name":"test", "shield":100,"energy":100
        },
        "payload": {
          "damage": 10, "enemy":"fucker"
        }
      }
    }

    post('action', options)
  end

  def update
    options = {
      body: {
        "name": "test",
        "shield": 100,
        "energy": 100
      }
    }
    post('update', options)
  end

  def scan
    options = {
      body: {
        "type": "scan",
        "state": {
          "name": "test",
          "shield": 100,
          "energy": 100
        },
        "payload": {
          "enemy": "fucker"
        }
      }
    }

    post('action', options)
  end

  private

  def post(path, options)
    HTTParty.post("http://#{ship_url}/#{path}", options)
  end


  def ship_url
    [@ship.source, @ship.port].join(":")
  end
end
