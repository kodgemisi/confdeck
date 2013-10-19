class Room < ActiveRecord::Base
  attr_accessible :name, :conference_id

  has_many :slots
end
