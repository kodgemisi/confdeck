class Sponsor < ActiveRecord::Base
  attr_accessible :conference_id, :name, :website

  belongs_to :conference
end
