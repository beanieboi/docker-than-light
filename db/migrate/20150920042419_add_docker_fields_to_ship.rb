class AddDockerFieldsToShip < ActiveRecord::Migration[4.2]
  def change
    add_column :ships, :container_id, :string
  end
end
