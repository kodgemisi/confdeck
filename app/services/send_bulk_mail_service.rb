class SendBulkMailService < BaseService
  def call(speech_ids)
    speech_ids.each do |id|
      speech = Speech.find(id)
      if speech.state == "accepted"
        SpeechMailer.accept_notification_email(speech).deliver unless speech.accept_mail_sent?
        speech.accept_mail_sent!
      elsif speech.state == "rejected"
        SpeechMailer.reject_notification_email(speech).deliver unless speech.reject_mail_sent?
        speech.reject_mail_sent!
      end
    end
  end
end