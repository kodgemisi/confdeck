class AddSettingsToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :settings, :string

    Conference.all.each do |c|
      c.save
    end
  end
end
