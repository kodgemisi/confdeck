class AddEmailFlagToComments < ActiveRecord::Migration
  def change
    add_column :comments, :sent_by_email, :boolean, default: false
  end
end
