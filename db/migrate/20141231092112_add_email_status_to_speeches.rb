class AddEmailStatusToSpeeches < ActiveRecord::Migration
  def change
    add_column :speeches, :email_status, :integer, default: 0
  end
end
