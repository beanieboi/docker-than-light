class AddLastChargedToShip < ActiveRecord::Migration
  def change
    add_column :ships, :last_charged_at, :datetime
  end
end
