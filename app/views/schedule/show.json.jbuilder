
    json.array! @conference.slots do |slot|
       json.(slot, :id)
       #json.start "Date(" + (slot.start_time.to_i * 1000).to_s + ")"
       #json.end "Date(" + (slot.end_time.to_i * 1000).to_s + ")"
       json.start (slot.start_time.to_i * 1000).to_s
       json.end (slot.end_time.to_i * 1000).to_s
       json.title slot.topic.subject
       json.room_id slot.room_id
       json.type_id slot.appeal_type.id
       json.topic_id slot.topic.id
    end

