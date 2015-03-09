class TranslateSpeechTypes < ActiveRecord::Migration
  def change
    add_column :speech_types, :type_name_tr, :string
    rename_column :speech_types, :type_name, :type_name_en
  end
end
