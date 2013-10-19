class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.integer :organization_id
      t.string :token
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
