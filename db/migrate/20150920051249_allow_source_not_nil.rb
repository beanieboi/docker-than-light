class AllowSourceNotNil < ActiveRecord::Migration
  def change
    change_column :ships, :source, :inet, :null => true
  end
end
