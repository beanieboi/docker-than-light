class AddSectorToShip < ActiveRecord::Migration[4.2]
  def change
    add_column :ships, :sector_id, :integer
  end
end
