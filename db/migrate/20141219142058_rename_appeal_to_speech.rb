class RenameAppealToSpeech < ActiveRecord::Migration
  def change
    rename_table :appeals, :speeches
  end
end
