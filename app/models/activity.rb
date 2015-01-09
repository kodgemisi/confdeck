class Activity < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :conference
  belongs_to :user

  after_create :set_conference


  def set_conference
    self.conference = subject.conference if self.conference.nil?
  end

  def target=(target)
    self.conference = target
  end
end
