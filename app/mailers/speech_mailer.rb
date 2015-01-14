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

  default from: "app@confdeck.com", content_type: "text/html"

  layout "email_layout"


  def committee_notification_email(speech)
    liquid_template = prepare(speech.conference, __method__, { "speech" => speech, "topic" => speech.topic, "conference" => speech.conference})
    mail(to: speech.conference.email, subject: liquid_template.subject, body: liquid_template.body)
  end

  def speaker_notification_email(speech)
    liquid_template = prepare(speech.conference, __method__, {"speech" => speech, "topic" => speech.topic, "conference" => speech.conference})
    speech.topic.speakers.each do |speaker|
      mail(reply_to: speech.conference.email, to: speaker.user.email, subject: liquid_template.subject, body: liquid_template.body) if speaker.user.email?
    end
  end

  def accept_notification_email(speech)
    speech.accept_mail_sent!
    liquid_template = prepare(speech.conference, __method__, {"speech" => speech, "topic" => speech.topic, "conference" => speech.conference})
    speech.topic.speakers.each do |speaker|
      mail(reply_to: speech.conference.email, to: speaker.user.email, subject: liquid_template.subject, body: liquid_template.body) if speaker.user.email?
    end
  end

  def reject_notification_email(speech)
    speech.reject_mail_sent!
    liquid_template = prepare(speech.conference, __method__, {"speech" => speech, "topic" => speech.topic, "conference" => speech.conference})
    speech.topic.speakers.each do |speaker|
      mail(reply_to: speech.conference.email, to: speaker.user.email, subject: liquid_template.subject, body: liquid_template.body) if speaker.user.email?
    end
  end
end
