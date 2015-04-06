class AddDurationToSpeechType < ActiveRecord::Migration
  def change
    add_column :speech_types, :duration, :integer, default: 0

    SpeechType.update_all({:duration => 30}) #Make current ones 30
  end
end
