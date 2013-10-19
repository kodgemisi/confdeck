class Sponsor < ActiveRecord::Base
  attr_accessible :conference_id, :name, :website, :logo

  belongs_to :conference

  has_attached_file :logo, :styles => { :default => "360x230>" }
end
