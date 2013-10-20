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

end
