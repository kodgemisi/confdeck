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
  friendly_id :name, use: :slugged

  has_attached_file :logo, :styles => { :medium => "400x400>", :thumb => "200x100>" }, :default_url => "/assets/missing_:style.png"
  has_attached_file :heading_image, :styles => { :default => "1900x254", :thumb => "200x100"}, :default_url => "/assets/heading_missing_:style.png"

  MODULES = %w{ application sponsors map organizators speakers schedule }

  #== Callbacks
  after_save :create_days_and_slot
  before_validation :set_dates
  before_save :set_default_settings
  after_create :set_virtual_dates

  #== Virtual Attributes
  attr_accessor :from_date
  attr_accessor :to_date
  attr_accessor :start_time
  attr_accessor :end_time

  serialize :settings

  #== Relations
  has_one :address
  has_and_belongs_to_many :organizations
  has_many :conference_roles
  has_many :users, through: :conference_roles
  has_many :conference_admins, -> { where(conference_roles: {role: ConferenceRole.roles[:confadmin] }) },
           :through => :conference_roles,
           :source => :user
  has_many :conference_users, -> { where(conference_roles: {role: ConferenceRole.roles[:confuser] }) },
           :through => :conference_roles,
           :source => :user

  has_and_belongs_to_many :days, -> { order 'date ASC' }
  has_many :sponsors
  has_many :rooms
  has_many :slots
  has_many :speeches
  has_many :activities
  #FIXME old one is
  #has_many :waiting_speeches, class_name: "Speech", conditions: {:state => "waiting_review"}
  has_many :waiting_speeches, class_name: "Speech"
  #FIXME old one is
  #has_many :accepted_speeches, class_name: "Speech", conditions: {:state => "accepted"}
  has_many :accepted_speeches, class_name: "Speech"
  has_many :speech_types
  has_many :topics, through: :speeches
  has_many :email_templates
  has_many :speakers, through: :topics do
    def accepted
      where("speeches.state = ?", "accepted")
    end
  end

  #== Nested Attributes
  accepts_nested_attributes_for :sponsors
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :organizations
  accepts_nested_attributes_for :days
  accepts_nested_attributes_for :email_templates
  accepts_nested_attributes_for :speech_types, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :conference_roles, allow_destroy: :true
  accepts_nested_attributes_for :conference_admins, allow_destroy: :true
  accepts_nested_attributes_for :conference_users, allow_destroy: :true

  #== Validations
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :heading_image, :content_type => /\Aimage\/.*\Z/
  validates_presence_of :name, :slug, :summary, :organizations, :email, :from_date, :to_date
  validates_uniqueness_of :slug
  validates_format_of :start_time, :with => /([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]/, :if => :one_day?
  validates_format_of :end_time, :with => /([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]/, :if => :one_day?
  validate :check_date_formats, if: "to_date.present? && from_date.present? "
  validate :check_date_interval, if: "to_date.present? && from_date.present?"


  def should_generate_new_friendly_id?
    name_changed?
  end

  def create_days_and_slot
    #FIXME should be refactored
    if (self.from_date && self.to_date)
      self.days.destroy_all
    end

    self.create_days(self.from_date, self.to_date)

    if one_day?
      create_one_day_slot!
    end
  end

  def create_days(from_date, to_date)
    _from_date = DateTime.strptime(from_date, I18n.t("date.formats.default"))
    _to_date = DateTime.strptime(to_date, I18n.t("date.formats.default"))

    current_date = _from_date
    begin
      day = Day.where(date: current_date.to_date).first_or_create
      self.days << day
      current_date = current_date.next_day
    end while current_date != _to_date.next_day
  end

  def one_day?
    (self.from_date == self.to_date)
  end

  def create_one_day_slot!
    self.slots.destroy_all #FIXME might be need to removed
    slot = self.slots.build
    slot.day = self.days.first

    from_date = slot.day.date
    start_time = Time.parse(self.start_time)
    end_time = Time.parse(self.end_time)
    slot.start_time = (from_date + start_time.seconds_since_midnight.seconds).to_datetime
    slot.end_time = (from_date + end_time.seconds_since_midnight.seconds).to_datetime
    slot.save
  end

  def unassigned_topics
    self.speeches.accepted.map {|a| a unless self.slots.pluck(:topic_id).include? a.topic_id }.reject { |a| a.nil? }
  end

  def module_enabled?(module_name)
    (self.settings["#{module_name}_module"] == "true")
  end

  def set!(key, val)
    self.settings ||= {}
    self.settings[key] = val
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

  def start_date
    self.days.first.date
  end

  def end_date
    self.days.last.date
  end

  private

  def set_dates
    if self.from_date.nil? && self.to_date.nil?
      self.from_date = self.days.first.try(:formatted)
      self.to_date = self.days.last.try(:formatted)
    end
  end

  # Checks from_date and to_date formats and converts String to Date type
  # Also checks 60 days time range validation
  def check_date_formats
    begin
      DateTime.strptime(self.from_date, I18n.t("date.formats.default"))
    rescue
      self.errors.add(:from_date, "invalid");
      #return false
    end

    begin
      DateTime.strptime(self.to_date, I18n.t("date.formats.default"))
    rescue
      self.errors.add(:to_date, "invalid");
    end
  end

  def check_date_interval
    _from_date = DateTime.strptime(self.from_date, I18n.t("date.formats.default"))
    _to_date = DateTime.strptime(self.to_date, I18n.t("date.formats.default"))

    if (_to_date < _from_date)
      self.errors.add(:to_date, "must be after from date")
    end

  end

  def set_virtual_dates
    set_dates
  end

  def set_default_settings
    if self.settings.nil?
      _settings = {}
      Conference::MODULES.each do |m|
        _settings["#{m}_module"] = "true".to_s
      end
      self.settings = _settings
    end
  end

end
