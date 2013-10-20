class Conference < ActiveRecord::Base
  attr_accessible :description, :email, :facebook, :name, :phone, :summary, :twitter, :website, :address_attributes, :organization_ids, :logo, :heading_image, :keywords

  has_one :address
  has_and_belongs_to_many :organizations
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
  has_attached_file :heading_image, :styles => { :default => "1900x254>", :thumb => "200x100>" }

  def create_days(from_date, to_date)
   current_date = from_date
   begin
    day = Day.find_or_create_by_date(current_date)
    self.days << day
    current_date = current_date.next_day
   end while current_date != to_date.next_day
  end

end
