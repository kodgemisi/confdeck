class Address < ActiveRecord::Base
  attr_accessible :conference_id, :info, :lat, :lon

  belongs_to :conference
end
