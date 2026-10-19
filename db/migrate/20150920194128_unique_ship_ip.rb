class UniqueShipIp < ActiveRecord::Migration[4.2]
  def change
    add_index :ships, :source, unique: true
  end
end
