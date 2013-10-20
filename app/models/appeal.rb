class Appeal < ActiveRecord::Base
  attr_accessible :conference_id, :topic_id, :topic_attributes, :comment, :state

  after_create :send_notifications

  belongs_to :conference
  belongs_to :topic

  accepts_nested_attributes_for :topic

  validates_presence_of :conference, :topic

  scope :accepted, -> { where(state: :accepted) }

  delegate :subject, to: :topic, prefix: true

  acts_as_commentable
  acts_as_votable

  state_machine :state, :initial => :waiting_review do
    event :accept do
      transition :waiting_review => :accepted
    end
    event :reject do
      transition :waiting_review => :rejected
    end

    after_transition :waiting_review => :accepted, :do => :send_accept_notification
    after_transition :waiting_review => :rejected, :do => :send_reject_notification
  end

  def send_accept_notification
    AppealMailer.accept_notification_email(self).deliver
  end

  def send_reject_notification
    AppealMailer.reject_notification_email(self).deliver
  end

  def send_notifications
    AppealMailer.speaker_notification_email(self).deliver
    AppealMailer.committee_notification_email(self).deliver
  end
end
