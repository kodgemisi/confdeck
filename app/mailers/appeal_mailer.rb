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
