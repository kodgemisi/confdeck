class AddAttachmentLogoToConferences < ActiveRecord::Migration
  def self.up
    change_table :conferences do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :conferences, :logo
  end
end
