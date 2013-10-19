class AddConferenceIdToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :conference_id, :integer
  end
end
