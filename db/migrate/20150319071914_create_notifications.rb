class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :subject_type
      t.integer :subject_id
      t.references :user, index: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
