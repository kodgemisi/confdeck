class RenameAppealTypeToSpeechType < ActiveRecord::Migration
  def change
    rename_table :appeal_types, :speech_types
  end
end
