class CreateSpeakers < ActiveRecord::Migration
  def change
    create_table :speakers do |t|
      t.string :email
      t.string :name
      t.string :phone
      t.string :twitter
      t.string :facebook

      t.timestamps
    end
  end
end
