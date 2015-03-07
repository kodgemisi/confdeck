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

class ConferenceMailer < ActionMailer::Base
  default from: "app@confdeck.com", content_type: "text/html"

  layout "email_layout"


  def digest_speeches(conference)
    @conference = conference
    @speech_types = @conference.speech_types.order("created_at ASC")
    @types = {}

    @speech_types.each do |speech_type|
      @types[speech_type.type_name] = speech_type.speeches.where("state = ?", "waiting_review")
    end

    mail(to: @conference.email, subject: I18n.t("mailers.conference_mailer.digest_speeches_subject", conference: @conference.name))
  end
end
