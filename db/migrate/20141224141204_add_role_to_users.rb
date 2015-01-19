class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, default: "user"
    User.all.each do |user|
      user.role = "user"
    end
  end
end
