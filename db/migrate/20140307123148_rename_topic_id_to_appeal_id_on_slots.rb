class RenameTopicIdToAppealIdOnSlots < ActiveRecord::Migration
  def change
    remove_column :slots, :topic_id
    add_column :slots, :appeal_id, :integer
  end
end
