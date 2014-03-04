class FixColumnNamesOnSlots < ActiveRecord::Migration
  def change
    remove_column :slots, :duration
    add_column :slots, :end_time, :datetime
    rename_column :slots, :start_hour, :start_time
  end
end
