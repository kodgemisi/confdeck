class Speaker < ActiveRecord::Base
  attr_accessible :email, :facebook, :name, :phone, :twitter

  has_and_belongs_to_many :topics
end
