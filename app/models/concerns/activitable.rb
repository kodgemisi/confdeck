module Activitable
  extend ActiveSupport::Concern

  private

  def create_activity!(user, conference, subject, action)
    activity = Activity.new
    activity.subject = subject
    activity.action = action
    activity.user = user
    activity.conference = conference
    conference.touch #cache invalidation
    activity.save
  end

end