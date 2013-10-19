class Topic < ActiveRecord::Base
  attr_accessible :abstract, :additional_info, :detail, :subject

  has_and_belongs_to_many :speakers
end
