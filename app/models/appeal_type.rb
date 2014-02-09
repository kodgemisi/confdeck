class AppealType < ActiveRecord::Base
  attr_accessible :conference_id, :type_name

  belongs_to :conference
  has_many :appeals
end
