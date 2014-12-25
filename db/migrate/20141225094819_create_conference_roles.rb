class CreateConferenceRoles < ActiveRecord::Migration
  def change
    create_table :conference_roles do |t|
      t.references :user, index: true
      t.references :conference, index: true
      t.integer :role

      t.timestamps
    end
  end
end
