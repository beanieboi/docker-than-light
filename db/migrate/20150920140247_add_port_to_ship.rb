class AddPortToShip < ActiveRecord::Migration[4.2]
  def change
    add_column :ships, :port, :integer
  end
end
