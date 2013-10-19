class Speaker < ActiveRecord::Base
  attr_accessible :email, :facebook, :name, :phone, :twitter, :bio, :github

  has_and_belongs_to_many :topics
end
