class CreateSectors < ActiveRecord::Migration[4.2]
  def change
    create_table :sectors do |t|
      t.text :name, null: false

      t.timestamps null: false
    end
  end
end
