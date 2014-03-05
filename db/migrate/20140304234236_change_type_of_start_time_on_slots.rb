class ChangeTypeOfStartTimeOnSlots < ActiveRecord::Migration
  def change
    remove_column :slots, :start_time
    add_column :slots, :start_time, :datetime

  end
end
