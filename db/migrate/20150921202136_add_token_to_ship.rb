class AddTokenToShip < ActiveRecord::Migration[4.2]
  def change
    add_column :ships, :token, :string
  end
end
