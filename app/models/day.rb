class Day < ActiveRecord::Base
  attr_accessible :date

  has_many :slots
end
