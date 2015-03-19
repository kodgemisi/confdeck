class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  layout false
  def index
    @notifications = current_user.notifications
  end
end
