class AllowSourceNotNil < ActiveRecord::Migration[4.2]
  def change
    change_column :ships, :source, :inet, :null => true
  end
end
