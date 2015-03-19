class Notification < ActiveRecord::Base
  enum status: [:unread, :read]
  belongs_to :subject, polymorphic: true
  belongs_to :user

  def activity?
    subject_type == 'Activity'
  end

  def comment?
    self.activity? && subject.subject_type == 'Comment'
  end

  def apply?
    self.activity? && subject.subject_type == 'Speech' && subject.action == 'speech_new'
  end
end
