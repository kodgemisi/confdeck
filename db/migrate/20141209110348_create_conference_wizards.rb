class CreateConferenceWizards < ActiveRecord::Migration
  def change
    create_table :conference_wizards do |t|
      t.text :data
      t.references :user, index: true

      t.timestamps
    end
  end
end
