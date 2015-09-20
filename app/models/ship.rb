class Ship < ActiveRecord::Base
  has_many :events
  belongs_to :sector

  validates :energy, inclusion: 1..100

  def fire!(other_ship)
    if can_fire?
      other_ship.hit!
      events.create!(event_name: "fire")
    end
  end

  def hit!(other_ship)
    self.update_attributes(energy: energy - 12)
  end

  def self.default_attributes
    { shield: 100, energy: 100, source: "127.0.0.1" }
  end

  private

  def can_fire?
    energy > 10
  end
end
