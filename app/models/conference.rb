class Conference < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :description, :email, :facebook, :name, :phone, :summary, :twitter, :website, :address_attributes, :organization_ids, :logo, :heading_image, :keywords, :slug

  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  has_one :address
  has_and_belongs_to_many :organizations
  has_many :users, through: :organizations, :uniq => true
  has_and_belongs_to_many :days
  has_many :sponsors
  has_many :rooms
  has_many :slots
  has_many :appeals
  has_many :topics, through: :appeals
  has_many :speakers, through: :topics, :uniq => true

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :organizations
  accepts_nested_attributes_for :days

  validates_presence_of :name, :organizations

  has_attached_file :logo, :styles => { :medium => "400x400>", :thumb => "200x100>" }, :default_url => "/assets/missing_:style.png"
  has_attached_file :heading_image, :styles => { :default => "1900x254", :thumb => "200x100"}

  def create_days(from_date, to_date)
   current_date = from_date
   begin
    day = Day.find_or_create_by_date(current_date)
    self.days << day
    current_date = current_date.next_day
   end while current_date != to_date.next_day
  end

  def unassigned_topics
    self.appeals.accepted.map {|a| a unless self.slots.pluck(:topic_id).include? a.topic_id }.reject { |a| a.nil? }
  end

  def accepted_topics
    self.appeals.accepted
  end

end
