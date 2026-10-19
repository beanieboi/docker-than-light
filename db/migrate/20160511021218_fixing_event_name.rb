class FixingEventName < ActiveRecord::Migration[4.2]
  def change
  	change_column :events, :event_name, :string
  end
end