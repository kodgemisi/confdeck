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

class OverlapValidator < ActiveModel::Validator
  #def validate(record)
  #  failed = false
  #  start_hour = record.start_date
  #  duration = record.duration
  #  slots = Slot.where(room_id: record.room_id, day_id: record.day_id, conference_id: record.conference_id, start_hour: record.start_hour..record.start_hour+(duration-1).minute)
  #
  #  if(slots.count > 1)
  #    record.errors[:start_hour] << 'Slots cannot overlap!'
  #    # p '===================================== 1'
  #    return
  #  elsif slots.count == 1 && !slots.include?(record)
  #    record.errors[:start_hour] << 'Slots cannot overlap!'
  #    # p '===================================== 2'
  #    return
  #  end
  #
  #  Slot.where(room_id: record.room_id, conference_id: record.conference_id).each do |slot|
  #    if(slot != record && slot.day_id == record.day_id && slot.room_id == record.room_id)
  #      range = slot.start_hour..slot.start_hour+(slot.duration-1).minute
  #      if(range.cover?(record.start_hour))
  #        record.errors[:start_hour] << 'Slots cannot overlap!'
  #        # p '===================================== 3', range, record, slot
  #        return
  #      end
  #    end
  #  end
  #
  #end
end

class Slot < ActiveRecord::Base
  attr_accessible :conference_id, :day_id, :room_id, :start_time, :end_time, :topic_id

  belongs_to :conference
  belongs_to :room
  belongs_to :day
  belongs_to :topic

  #validates_with OverlapValidator

end
