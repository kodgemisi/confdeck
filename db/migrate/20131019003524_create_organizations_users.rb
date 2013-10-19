class CreateOrganizationsUsers < ActiveRecord::Migration
  def up
    create_table :organizations_users, :id => false do |t|
      t.integer :user_id
      t.integer :organization_id
    end
  end

  def down
    drop_table :organizations_users
  end
end
