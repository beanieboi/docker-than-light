class RemoveShipSourceUnique < ActiveRecord::Migration[4.2]
  def change
    remove_index :ships, :source
  end
end
