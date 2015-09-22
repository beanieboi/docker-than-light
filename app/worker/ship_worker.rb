class ShipWorker
  include Sidekiq::Worker

  def perform
    Ship.find_each do |ship|
      client = ShipClient.new(ship)
      client.update
    end
  end
end
