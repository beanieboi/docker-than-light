class AddSectorToShip < ActiveRecord::Migration
  def change
    add_column :ships, :sector_id, :integer
  end
end
