class CreateAppeals < ActiveRecord::Migration
  def change
    create_table :appeals do |t|
      t.integer :conference_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
