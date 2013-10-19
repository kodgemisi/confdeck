class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :website
      t.integer :conference_id

      t.timestamps
    end
  end
end
