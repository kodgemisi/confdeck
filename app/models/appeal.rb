class Appeal < ActiveRecord::Base
  attr_accessible :conference_id, :topic_id, :topic_attributes, :comment

  after_create :send_notifications

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

   def send_notifications
     AppealMailer.speaker_notification_email(self).deliver
     AppealMailer.committee_notification_email(self).deliver
   end
end
