class Ship < ActiveRecord::Base

  def self.default_attributes
    { shield: 100, energy: 100, source: "127.0.0.1" }
  end
end
