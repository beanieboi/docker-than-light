class AddTokenToShip < ActiveRecord::Migration
  def change
    add_column :ships, :token, :string
  end
end
