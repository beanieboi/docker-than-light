class FixingEventName < ActiveRecord::Migration
  def change
  	change_column :events, :event_name, :string
  end
end
