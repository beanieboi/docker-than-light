class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :ship_id, null: false
      t.integer :event_name, null: false
      t.json :event_attributes
      t.timestamps null: false
    end
  end
end
