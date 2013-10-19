class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :subject
      t.string :abstract
      t.text :detail
      t.text :additional_info

      t.timestamps
    end
  end
end
