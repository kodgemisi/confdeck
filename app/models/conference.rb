class Conference < ActiveRecord::Base
  attr_accessible :description, :email, :facebook, :name, :phone, :summary, :twitter, :website, :address_attributes

  has_one :address
  has_and_belongs_to_many :organizations

  accepts_nested_attributes_for :address
end
