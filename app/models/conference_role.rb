class ConferenceRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference
  enum role: [:confadmin, :confuser]
  validates_uniqueness_of :user_id, :scope => [:conference, :role]

end
