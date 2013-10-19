class CreateConferencesDays < ActiveRecord::Migration
  def up
    create_table :conferences_days, :id => false do |t|
      t.integer :conference_id
      t.integer :organization_id
    end
  end

  def down
    drop_table :conferences_days
  end
end
