module NotificationsHelper

  def notification_link(notification)
    if notification.comment?
      admin_speech_url(subdomain: notification.subject.subject.commentable.conference.slug, id: notification.subject.subject.commentable_id)
    end
  end

  def notification_text(notification)
    if notification.comment?
      comment = notification.subject.subject
      user = notification.subject.user
      t('notifications.comment', user: user.display_name, comment: comment.comment, speech: comment.commentable.topic.subject).html_safe
    end
  end
end
