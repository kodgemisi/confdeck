class Conference < ActiveRecord::Base
  attr_accessible :description, :email, :facebook, :name, :phone, :summary, :twitter, :website, :address_attributes, :organization_ids, :logo

  has_one :address
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :days
  has_many :sponsors

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :organizations
  accepts_nested_attributes_for :days

  validates_presence_of :name, :organizations

  has_attached_file :logo, :styles => { :medium => "400x400>", :thumb => "200x100>" }
end
