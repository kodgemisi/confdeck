class AppealType < ActiveRecord::Base
  belongs_to :conference
  has_many :appeals
end
