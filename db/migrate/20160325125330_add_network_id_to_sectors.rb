class AddNetworkIdToSectors < ActiveRecord::Migration[4.2]
  def change
  	add_column :sectors, :network_id, :string
  end
end
