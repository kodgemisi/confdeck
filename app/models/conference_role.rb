class ConferenceRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference
  enum role: [:confadmin, :confuser]

end
