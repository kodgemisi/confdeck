class AddSettingsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :settings, :string
    User.all.each do |user|
      user.set_default_settings
      user.save
    end
  end

  def down
    remove_column :users, :settings
  end
end
