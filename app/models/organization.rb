class Organization < ActiveRecord::Base
  attr_accessible :name, :website, :logo

  has_and_belongs_to_many :users
  has_and_belongs_to_many :conferences

  validates_presence_of :name

  has_attached_file :logo, :styles => {:medium => "400x400>", :thumb => "200x200>"}, :default_url => "/assets/missing_org_:style.png"

end
