class ShipWorker
  include Sidekiq::Worker

  def perform
    Ship.find_each do |ship|
      client = ship_client(ship)
      client.update

      unless client.ping
        swarm_client.destroy_ship(ship)
      end
    end
  end

  private

  def swarm_client
    SwarmClient.new
  end

  def ship_client(ship)
    ShipClient.new(ship)
  end

end
