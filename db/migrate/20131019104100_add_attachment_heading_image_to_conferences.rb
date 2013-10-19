class AddAttachmentHeadingImageToConferences < ActiveRecord::Migration
  def self.up
    change_table :conferences do |t|
      t.attachment :heading_image
    end
  end

  def self.down
    drop_attached_file :conferences, :heading_image
  end
end
