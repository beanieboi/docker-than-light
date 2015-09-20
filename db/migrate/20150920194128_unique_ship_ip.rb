class UniqueShipIp < ActiveRecord::Migration
  def change
    add_index :ships, :source, unique: true
  end
end
