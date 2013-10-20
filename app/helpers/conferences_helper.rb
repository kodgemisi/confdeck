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
          r[slot.id] = slot
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

end
