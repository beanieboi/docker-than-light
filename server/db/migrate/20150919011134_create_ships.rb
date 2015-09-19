class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.text :name, null: false
      t.text :image, null: false
      t.inet :source, null: false
      t.integer :shield, null: false
      t.integer :energy, null: false
      t.timestamps null: false
    end
  end
end
