class Address < ActiveRecord::Base
  attr_accessible :conference_id, :info, :lat, :lon, :city

  belongs_to :conference
end
