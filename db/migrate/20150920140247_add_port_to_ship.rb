class AddPortToShip < ActiveRecord::Migration
  def change
    add_column :ships, :port, :integer
  end
end
