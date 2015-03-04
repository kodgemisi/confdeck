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
    @speech_types = @conference.speech_types.includes(speeches: [:comments, :votes, topic: :speakers ]).order("created_at ASC")
    mail(to: @conference.email, subject: I18n.t("conferences.speeches_digest", conference: @conference.name))
  end
end