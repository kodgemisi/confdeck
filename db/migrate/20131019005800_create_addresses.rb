class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.text :info
      t.float :lat
      t.float :lon
      t.integer :conference_id

      t.timestamps
    end
  end
end
