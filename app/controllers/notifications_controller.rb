class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  layout false
  def index
    @notifications = current_user.notifications.includes(:subject)
  end

  def read_all
    current_user.notifications.update_all('status = 1')
  end
end
