module NotificationsHelper

  def notification_link(notification)
    if notification.comment?
      admin_speech_url(subdomain: notification.subject.subject.commentable.conference.slug, id: notification.subject.subject.commentable_id)
    end
  end
end
