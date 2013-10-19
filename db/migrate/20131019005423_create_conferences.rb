class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :name
      t.string :summary
      t.text :description
      t.string :website
      t.string :twitter
      t.string :facebook
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
