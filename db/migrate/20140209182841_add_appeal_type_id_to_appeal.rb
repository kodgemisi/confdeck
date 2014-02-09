class AddAppealTypeIdToAppeal < ActiveRecord::Migration
  def change
    add_column :appeals, :appeal_type_id, :integer
  end
end
