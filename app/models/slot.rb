class OverlapValidator < ActiveModel::Validator
  def validate(record)
    failed = false
    start_hour = record.start_hour
    duration = record.duration
    slots = Slot.where(room_id: record.room_id, conference_id: record.conference_id, start_hour: record.start_hour..record.start_hour+(duration-1).minute)
    
    if(slots.count > 1)
      record.errors[:start_hour] << 'Slots cannot overlap!'
      # p '===================================== 1'
      return
    elsif slots.count == 1 && !slots.include?(record)
      record.errors[:start_hour] << 'Slots cannot overlap!'
      # p '===================================== 2'
      return
    end

    Slot.where(room_id: record.room_id, conference_id: record.conference_id).each do |slot|
      if(slot != record)
        range = slot.start_hour..slot.start_hour+(slot.duration-1).minute
        if(range.cover?(record.start_hour))
          record.errors[:start_hour] << 'Slots cannot overlap!'
          # p '===================================== 3', range, record, slot
          return
        end
      end
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
