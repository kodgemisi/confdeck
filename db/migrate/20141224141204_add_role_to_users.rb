class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer
    User.all.each do |user|
      user.role = "confadmin"
    end
  end
end
