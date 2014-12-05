class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :subject_id
      t.string :subject_type
      t.string :action
      t.references :conference, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
