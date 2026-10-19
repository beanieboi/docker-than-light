class UniqueShipName < ActiveRecord::Migration[4.2]
  def change
    add_index :ships, :name, unique: true
  end
end
