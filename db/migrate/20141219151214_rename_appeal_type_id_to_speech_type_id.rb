class RenameAppealTypeIdToSpeechTypeId < ActiveRecord::Migration
  def change
    rename_column :speeches, :appeal_type_id, :speech_type_id
    rename_column :slots, :appeal_id, :speech_id
  end

end
