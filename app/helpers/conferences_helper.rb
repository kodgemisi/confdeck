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

module ConferencesHelper

  # days = {
  #   day_id: {
  #     room_id: {
  #       slot_id: {
  #         slot
  #       }
  #     }
  #   }
  # }
  def self.slots_data(conference)
    days = {}
    rooms = conference.rooms

    conference.days.each do |day| 
      d = {}

      rooms.each do |room|
        r = {}
        Slot.where(conference_id: conference.id, day_id: day[:id], room_id: room[:id]).each do |slot|
          s = slot
          s[:topic] = slot.topic
          r[slot.id] = s
        end
        d[room[:id]] = r
      end

      days[day[:id]] = d
    end

    return days.to_json
  end

  def self.hour_span(conference, editable)
    if(editable)
      return 7..23
    else
      hours = conference.slots.map do |slot|
        slot.start_hour.hour
      end
      start_end = hours.minmax
      return start_end[0]..start_end[1]
    end
  end

  def template_saved?(template_hash, tt)
    (template_hash[tt.type_name].present? && template_hash[tt.type_name].email_template_type_id == tt.id)
  end

  def remaining_days(conference)
    days = (conference.days.first.date - Date.today).to_i
    return days <= 0 ? 0 : days
  end

  def appeal_ribbon(appeal)
    if appeal.state == "waiting_review"
      '<a href="javascript:void(0);" class="panel-ribbon panel-ribbon-warning pull-left"><i class="ico-clock3"></i></a>'
    elsif appeal.state == "accepted"
      '<a href="javascript:void(0);" class="panel-ribbon panel-ribbon-success pull-left"><i class="ico-ok"></i></a>'
    else
      '<a href="javascript:void(0);" class="panel-ribbon panel-ribbon-danger pull-left"><i class="ico-ok"></i></a>'
    end
  end

  def conference_dates(conference)
    if conference.days.first.date == conference.days.last.date
      "#{conference.days.first.date.strftime(t('date.formats.short'))}".html_safe
    else
      "#{conference.days.first.date.strftime(t('date.formats.short'))} #{conference.days.last.date.strftime(t('date.formats.short'))}".html_safe
    end
  end
end
