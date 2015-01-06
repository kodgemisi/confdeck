
class SpeakerMailer < ActionMailer::Base
  include TemplateMailer

  default from: "app@confdeck.com", content_type: "text/html"

  layout "email_layout"

  # Send when non-user added as speaker
  def new_speaker_mail(speaker, user, password)
    @speaker = speaker
    @user = user
    @password = password
    mail(to: user.email, subject: t("mailers.speaker_mailer.new_speaker_subject"))
  end

end