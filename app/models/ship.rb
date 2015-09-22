class Ship < ActiveRecord::Base
  has_many :events
  belongs_to :sector

  validates :energy, inclusion: 1..100

  # Time, Energy, Probability of success
  Costs = {
    "fire"   => [1, 12, 0.75],
    "scan"   => [3, 5,  0.9],
    "travel" => [5, 15, 0.85]
  }
  FIRE_DAMAGE = 10

  def fire!(other_ship)
    if can_fire? && in_same_sector?(other_ship)
      # FIRE
      cost = Costs["fire"]
      self.update_attributes(energy: energy - cost[1])
      events.create!(event_name: "fire")
      # SHOT IN FLIGHT
      sleep(cost[0])
      # HIT?
      if in_same_sector?(other_ship.reload)
        if rand < cost[2]
          # HIT!
          other_ship.hit!(self)
          events.create!(event_name: "on_target")
          return true
        end
      end
      events.create!(event_name: "miss")
    end
    return false
  end

  def hit!(other_ship)
    # TODO send notification to ship
    self.update_attributes(shield: shield - FIRE_DAMAGE)
    events.create!(event_name: "hit")
    if shield <= 0 
      events.create!(event_name: "destroyed")
      # TODO clean up container
    end
  end

  def scan!
    if can_scan?
      # SCAN
      cost = Costs["scan"]
      self.update_attributes(energy: energy - cost[1])
      events.create!(event_name: "scanning")
      if rand < cost[2]
        # SUCCESS
        return true
      end
    end
    return false
  end

  def travel!(sector)
    if can_travel?
      # TRAVEL
      cost = Costs["travel"]
      self.update_attributes(energy: energy - cost[1])
      events.create!(event_name: "travelling")
      if rand < cost[2]
        # SUCCESS
        self.update_attributes(sector: sector)
        return true
      end
    end
    return false
  end

  def self.default_attributes
    { shield: 100, energy: 100, token: SecureRandom.uuid }
  end

  private

  def can_fire?
    energy >= Costs["fire"][1]
  end

  def can_scan?
    energy >= Costs["scan"][1]
  end

  def can_travel?
    energy >= Costs["travel"][1]
  end

  def in_same_sector?(other_ship)
    sector == other_ship.sector
  end
end
