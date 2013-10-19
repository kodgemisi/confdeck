class Appeal < ActiveRecord::Base
  attr_accessible :conference_id, :topic_id

  belongs_to :conference
  belongs_to :topic
end
