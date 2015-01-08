    json.array! @conference.slots do |slot|
       json.(slot, :id)
       #json.start "Date(" + (slot.start_time.to_i * 1000).to_s + ")"
       #json.end "Date(" + (slot.end_time.to_i * 1000).to_s + ")"
       json.start (slot.start_time.to_i * 1000).to_s
       json.end (slot.end_time.to_i * 1000).to_s
       json.title slot.speech.topic.subject
       json.room_id slot.room_id
       json.type_id slot.speech_type.id
       json.speech_id slot.speech.id
    end

