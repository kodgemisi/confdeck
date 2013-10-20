class Day < ActiveRecord::Base
  attr_accessible :date

  has_many :slots
  has_and_belongs_to_many :conferences

end
