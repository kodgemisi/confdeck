class SpeechType < ActiveRecord::Base
  translates :type_name

  belongs_to :conference
  has_many :speeches
end
