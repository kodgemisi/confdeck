class Sponsor < ActiveRecord::Base
  attr_accessible :conference_id, :name, :website, :logo

  belongs_to :conference

  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
