class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :email, null: false
      t.integer :github_uid, null: false
      t.timestamps null: false
    end
  end
end
