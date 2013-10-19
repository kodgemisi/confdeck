class Appeal < ActiveRecord::Base
  attr_accessible :conference_id, :topic_id, :topic_attributes, :comment

  belongs_to :conference
  belongs_to :topic

  accepts_nested_attributes_for :topic

  validates_presence_of :conference, :topic

  acts_as_commentable
  acts_as_votable

   state_machine :state, :initial => :waiting_review do
     event :accept do
       transition :waiting_review => :accepted
     end
     event :reject do
       transition :waiting_review => :rejected
     end
   end
end
