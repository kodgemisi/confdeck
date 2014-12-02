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

class Conference < ActiveRecord::Base
  extend FriendlyId
  before_save :check_dates

  friendly_id :name, use: :slugged

  attr_accessor :from_date
  attr_accessor :to_date

  def should_generate_new_friendly_id?
    name_changed?
  end

  has_one :address
  has_and_belongs_to_many :organizations
  has_many :users, through: :organizations
  has_and_belongs_to_many :days
  has_many :sponsors
  has_many :rooms
  has_many :slots
  has_many :appeals
  #FIXME old one is
  #has_many :waiting_appeals, class_name: "Appeal", conditions: {:state => "waiting_review"}
  has_many :waiting_appeals, class_name: "Appeal"
  #FIXME old one is
  #has_many :accepted_appeals, class_name: "Appeal", conditions: {:state => "accepted"}
  has_many :accepted_appeals, class_name: "Appeal"
  has_many :appeal_types
  has_many :topics, through: :appeals
  has_many :email_templates
  has_many :speakers, through: :topics do
    def accepted
      where("appeals.state = ?", "accepted")
    end
  end



  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :organizations
  accepts_nested_attributes_for :days
  accepts_nested_attributes_for :email_templates
  accepts_nested_attributes_for :appeal_types
  validates_presence_of :name, :organizations, :email, :from_date, :to_date


  #validates :from_date, date: true
  #validates :to_date, date: true
  #validates :from_date, date: { before: :to_date }
  validate :valid_from_date?
  validate :valid_to_date?
  def valid_from_date?
    begin
      DateTime.strptime(from_date, I18n.t("date.formats.default"))
    rescue
      errors.add(:from_date, I18n.t("errors.date.invalid"))
    end
  end

  def valid_to_date?
    begin
      DateTime.strptime(to_date, I18n.t("date.formats.default"))
    rescue
      errors.add(:to_date, I18n.t("errors.date.invalid"))
    end
  end
  has_attached_file :logo, :styles => { :medium => "400x400>", :thumb => "200x100>" }, :default_url => "/assets/missing_:style.png"
  has_attached_file :heading_image, :styles => { :default => "1900x254", :thumb => "200x100"}, :default_url => "/assets/heading_missing_:style.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :heading_image, :content_type => /\Aimage\/.*\Z/


  def create_days(from_date, to_date)
   current_date = from_date
   begin
    day = Day.where(date: current_date).first_or_create
    self.days << day
    current_date = current_date.next_day
   end while current_date != to_date.next_day
  end

  def unassigned_topics
    self.appeals.accepted.map {|a| a unless self.slots.pluck(:topic_id).include? a.topic_id }.reject { |a| a.nil? }
  end

  def to_liquid
    liquid_vars = {
        'name' => name,
        'summary' => summary,
        'description' => description,
        'twitter' => twitter,
        'facebook' => facebook,
        'website' => website,
        'logo_path' => logo.url,
        'email' => email,
        'phone' => phone,
        'organizations' => organizations
    }

    liquid_vars[:organization] = organizations.first if organizations.count == 1
    liquid_vars
  end

  private
    def check_dates
      from_date = Date.strptime(self.from_date, I18n.t("date.formats.default"))
      to_date = Date.strptime(self.to_date, I18n.t("date.formats.default"))

      if (to_date - from_date).to_i > 60
        errors[:base] = I18n.t("conferences.too_long")
        return false
      else
        return true
      end
    end
end
