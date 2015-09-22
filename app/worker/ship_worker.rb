class ShipWorker
  include Sidekiq::Worker

  def perform
    Ship.each do |ship|
      # ping ship
    end
  end
end
