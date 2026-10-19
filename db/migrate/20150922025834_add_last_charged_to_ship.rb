class AddLastChargedToShip < ActiveRecord::Migration[4.2]
  def change
    add_column :ships, :last_charged_at, :datetime
  end
end
