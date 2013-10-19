class Slot < ActiveRecord::Base
  attr_accessible :conference_id, :day_id, :duration, :room_id, :start_hour, :topic_id

  belongs_to :conference
  belongs_to :room
  belongs_to :day
  belongs_to :topic

end
