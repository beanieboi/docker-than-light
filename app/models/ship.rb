class Ship < ActiveRecord::Base
  has_many :events
  belongs_to :sector

  def fire!
    events.create!(event_name: "fire")
  end

  def self.default_attributes
    { shield: 100, energy: 100, source: "127.0.0.1" }
  end
end
