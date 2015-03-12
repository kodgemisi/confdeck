# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

class SpeechMailer < ActionMailer::Base
  include TemplateMailer

  default from: Rails.configuration.reply_emailer_from, content_type: "text/html"

  layout "email_layout"


  def committee_notification_email(speech)
    liquid_template = prepare(speech.conference, __method__, { "speech" => speech, "topic" => speech.topic, "conference" => speech.conference})
    mail(to: speech.conference.email, subject: speech_subject(speech), body: liquid_template.body)
  end

  def speaker_notification_email(speech)
    liquid_template = prepare(speech.conference, __method__, {"speech" => speech, "topic" => speech.topic, "conference" => speech.conference})
    emails = speech.topic.speakers.collect(&:user).collect(&:email).join(",")
    mail(reply_to: speech.conference.email, to: emails, subject: liquid_template.subject, body: liquid_template.body)
  end

  def accept_notification_email(speech)
    speech.accept_mail_sent!
    liquid_template = prepare(speech.conference, __method__, {"speech" => speech, "topic" => speech.topic, "conference" => speech.conference})
    emails = speech.topic.speakers.collect(&:user).collect(&:email).join(",")
    mail(reply_to: speech.conference.email, to: emails, subject: liquid_template.subject, body: liquid_template.body)
  end

  def reject_notification_email(speech)
    speech.reject_mail_sent!
    liquid_template = prepare(speech.conference, __method__, {"speech" => speech, "topic" => speech.topic, "conference" => speech.conference})
    emails = speech.topic.speakers.collect(&:user).collect(&:email).join(",")
    mail(reply_to: speech.conference.email, to: emails, subject: liquid_template.subject, body: liquid_template.body)
  end


  def new_comment_email(speech, comment)
    @server = Rails.configuration.reply_emailer_host
    @from = Rails.configuration.reply_emailer_from
    @conference = speech.conference
    @comment = comment
    @user = comment.user
    headers 'Reply-To' => "reply+speech-#{speech.id}@#{@server}"
    mail(from: @from, to: @conference.email, subject: speech_subject(speech), conference: @conference.name, speech: speech.topic.subject)
  end

  private

    #For threading in emails
    def speech_subject(speech)
      #First email is committee_notification_email. Other emails must have same title
      liquid_template = prepare(speech.conference, 'committee_notification_email', { "speech" => speech, "topic" => speech.topic, "conference" => speech.conference})

      "#{liquid_template.subject} #{speech.thread_title}"
    end
end
