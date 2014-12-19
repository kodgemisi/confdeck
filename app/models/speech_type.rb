class SpeechType < ActiveRecord::Base
  belongs_to :conference
  has_many :speeches
end
