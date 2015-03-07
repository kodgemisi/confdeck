class AddApplicationDatesToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :application_end, :datetime
  end
end
