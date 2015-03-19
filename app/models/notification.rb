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
end
