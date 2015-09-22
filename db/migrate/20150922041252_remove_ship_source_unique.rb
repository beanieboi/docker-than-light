class RemoveShipSourceUnique < ActiveRecord::Migration
  def change
    remove_index :ships, :source
  end
end
