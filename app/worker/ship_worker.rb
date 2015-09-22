class ShipWorker
  include Sidekiq::Worker

  def perform
    Ship.find_each do |ship|
      # ping ship
    end
  end
end
