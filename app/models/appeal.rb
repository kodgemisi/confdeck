class Appeal < ActiveRecord::Base
  attr_accessible :conference_id, :topic_id, :topic_attributes

  belongs_to :conference
  belongs_to :topic

  accepts_nested_attributes_for :topic

  validates_presence_of :conference, :topic
end