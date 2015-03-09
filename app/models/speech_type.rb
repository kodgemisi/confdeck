class SpeechType < ActiveRecord::Base
  translates :type_name, fallback: :any

  belongs_to :conference
  has_many :speeches
end
