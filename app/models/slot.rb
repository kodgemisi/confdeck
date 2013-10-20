class OverlapValidator < ActiveModel::Validator
  def validate(record)
    failed = false
    start_hour = record.start_hour
    duration = record.duration
    slots = Slot.where(room_id: record.room_id, conference_id: record.conference_id, start_hour: record.start_hour..record.start_hour+(duration-1).minute)
    
    if(slots.count > 1)
      failed = true
    elsif slots.count == 1 && !slots.include?(record)
      failed = true
    end

    Slot.where(room_id: record.room_id, conference_id: record.conference_id).each do |slot|
      if(slot != record)
        range = slot.start_hour..slot.start_hour+(duration-1).minute
        if(range.cover?(record.start_hour))
          failed = true
        end
      end
    end

    if failed
      record.errors[:start_hour] << 'Slots cannot overlap!'
    end
  end
end

class Slot < ActiveRecord::Base
  attr_accessible :conference_id, :day_id, :duration, :room_id, :start_hour, :topic_id

  belongs_to :conference
  belongs_to :room
  belongs_to :day
  belongs_to :topic

  validates_with OverlapValidator

end
