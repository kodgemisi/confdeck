# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

class Speech < ActiveRecord::Base
  after_create :send_notifications

  belongs_to :conference
  belongs_to :topic
  belongs_to :speech_type
  has_one :slot

  accepts_nested_attributes_for :topic

  validates_presence_of :conference, :topic

  scope :accepted, -> { where(state: :accepted) }

  delegate :subject, to: :topic, prefix: true

  acts_as_commentable
  acts_as_votable

  state_machine :state, :initial => :waiting_review do
    event :accept do
      transition :waiting_review => :accepted
    end
    event :reject do
      transition :waiting_review => :rejected
    end

    #after_transition :waiting_review => :accepted, :do => :send_accept_notification
    #after_transition :waiting_review => :rejected, :do => :send_reject_notification
  end

  def send_accept_notification
    SpeechMailer.accept_notification_email(self).deliver
  end

  def send_reject_notification
    SpeechMailer.reject_notification_email(self).deliver
  end

  def send_notifications
    SpeechMailer.speaker_notification_email(self).deliver
    SpeechMailer.committee_notification_email(self).deliver
  end

  def to_liquid
    {
        'conference' => conference,
        'topic' => topic,
        'speech_type' => speech_type,
        'state' => state,
        'speakers' => topic.speakers
    }
  end
end