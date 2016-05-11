class AddNetworkIdToSectors < ActiveRecord::Migration
  def change
  	add_column :sectors, :network_id, :string
  end
end
