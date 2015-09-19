class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.inet :source, null: false

      t.integer :maximum_shield, null: false
      t.integer :recharge_rate, null: false
      t.integer :energy_reserve, null: false
      t.integer :fire_rate, null: false
      t.integer :weapon_damage, null: false
      t.integer :accuracy, null: false
      t.integer :stealth, null: false
      t.timestamps null: false
    end
  end
end
