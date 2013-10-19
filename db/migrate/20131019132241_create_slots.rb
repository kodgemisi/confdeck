class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.time :start_hour
      t.integer :duration
      t.integer :conference_id
      t.integer :day_id
      t.integer :room_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
