class AppealType < ActiveRecord::Base
  validates :type_name, presence: true

  attr_accessible :conference_id, :type_name

  belongs_to :conference
  has_many :appeals
end
