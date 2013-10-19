class Topic < ActiveRecord::Base
  attr_accessible :abstract, :additional_info, :detail, :subject, :speaker_ids

  has_and_belongs_to_many :speakers
end
