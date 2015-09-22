class ShipWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    secondly(5)
  end

  def perform
    Ship.each do |ship|
      # ping ship
    end
  end
end
