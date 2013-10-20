class AppealMailer < ActionMailer::Base
  default from: "confmanrumble@gmail.com"

  def committee_notification_email(appeal)
   @appeal = appeal
   subject = "[#{appeal.topic.subject}] New application: #{appeal.topic.subject}"
   if appeal.conference.email?
    mail(to: appeal.conference.email, subject: subject)
   else
    appeal.conference.organizations.each do |org|
     org.users.each do |user|
      mail(to: user.email, subject: subject) if user.email?
     end
    end
   end
  end

  def speaker_notification_email(appeal)
   @appeal = appeal
   subject = "[#{appeal.topic.subject}] #{appeal.topic.subject} application is received"
   appeal.topic.speakers.each do |speaker|
     mail(to: speaker.email, subject: subject) if speaker.email?
   end
  end

  def accept_notification_email(appeal)
   @appeal = appeal
   subject = "[#{appeal.topic.subject}] #{appeal.topic.subject} application is accepted"
   appeal.topic.speakers.each do |speaker|
    mail(to: speaker.email, subject: subject) if speaker.email?
   end
  end

  def reject_notification_email(appeal)
   @appeal = appeal
   subject = "[#{appeal.topic.subject}] #{appeal.topic.subject} application is rejected"
   appeal.topic.speakers.each do |speaker|
    mail(to: speaker.email, subject: subject) if speaker.email?
   end
  end
end
