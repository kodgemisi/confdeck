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

module SpeechesHelper

  def state_label(state)
    if state == "accepted"
      "<span class=\"label label-success\">#{t("speeches.states.accepted")}</span>"
    elsif state == "rejected"
      "<span class=\"label label-danger\">#{t("speeches.states.rejected")}</span>"
    elsif state == "waiting_review"
      "<span class=\"label label-warning\">#{t("speeches.states.waiting_review")}</span>"
    end
  end

  def email_status_label(status)
    "<span class=\"label\">#{status.humanize}</span>"
  end

  def schedule_desc(speech)
    ''
  end
end
