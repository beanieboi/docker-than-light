class Ship < ActiveRecord::Base
  has_many :events
  belongs_to :sector

  validates :energy, inclusion: 0..100

  # Time, Energy, Probability of success
  Costs = {
    "fire"   => [1, 12, 0.75],
    "scan"   => [3, 5,  0.9],
    "travel" => [5, 15, 0.85]
  }
  FIRE_DAMAGE = 10
  RECHARGE_RATE = 10
  MAX_ENERGY = 100

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
    self.update_attributes(shield: shield - FIRE_DAMAGE)
    events.create!(event_name: "hit")

    if shield <= 0
      events.create!(event_name: "destroyed")
      swarm_client.destroy_ship(self)
    else
      ship_client.hit(other_ship)
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
        old_sector = self.sector
        self.update_attributes(sector: sector)
        swarm_client.switch_network(self, old_sector, sector)
        return true
      end
    end
    return false
  end

  def self.default_attributes
    { shield: 100, energy: 100, token: SecureRandom.uuid, last_charged_at: DateTime.now, sector: Sector.first }
  end

  def spawn
    swarm_client.create_ship(self)
  end

  private

  def ship_client
    ShipClient.new(self)
  end

  def swarm_client
    SwarmClient.new
  end

  def can_fire?
    charge
    energy >= Costs["fire"][1]
  end

  def can_scan?
    charge
    energy >= Costs["scan"][1]
  end

  def can_travel?
    charge
    energy >= Costs["travel"][1]
  end

  def charge
    n = DateTime.now

    numSecs = ((n.to_datetime - last_charged_at.to_datetime) * 24 * 60*60).to_i
    new_energy = energy + (numSecs * RECHARGE_RATE)
    if new_energy > MAX_ENERGY
      new_energy = MAX_ENERGY
    end
    update_attribute(:energy, new_energy)
    update_attribute(:last_charged_at, n)
  end

  def in_same_sector?(other_ship)
    sector == other_ship.sector
  end
end
