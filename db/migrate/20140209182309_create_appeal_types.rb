class CreateAppealTypes < ActiveRecord::Migration
  def change
    create_table :appeal_types do |t|
      t.integer :conference_id
      t.string :type_name

      t.timestamps
    end
  end
end
