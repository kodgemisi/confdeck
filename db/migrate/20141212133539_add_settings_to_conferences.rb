class AddSettingsToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :settings, :string
  end
end
