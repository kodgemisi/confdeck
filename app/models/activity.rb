class Activity < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :conference
  belongs_to :user

  after_create :create_notification



  # TODO background job
  def create_notification
    conference.users.each do |user|
      Notification.create(
          subject: self,
          user: user
      )
    end
  end

end
