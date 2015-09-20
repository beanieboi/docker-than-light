class UniqueShipName < ActiveRecord::Migration
  def change
    add_index :ships, :name, unique: true
  end
end
