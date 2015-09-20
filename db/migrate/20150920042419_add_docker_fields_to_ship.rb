class AddDockerFieldsToShip < ActiveRecord::Migration
  def change
    add_column :ships, :container_id, :string
  end
end
