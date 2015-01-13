class Activity < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :conference
  belongs_to :user

end
