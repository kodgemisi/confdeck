class Organization < ActiveRecord::Base
  attr_accessible :name, :website

  has_and_belongs_to_many :users
  has_and_belongs_to_many :conferences
end
