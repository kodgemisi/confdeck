class SpeakerForm < BaseForm

  attr_accessor :user
  attr_accessor :speaker

  attribute :name, String
  attribute :phone, String
  attribute :twitter, String
  attribute :facebook, String
  attribute :email, String

  validates_presence_of :email
  validates :name, :phone, presence: true, unless: :user_exists?

  def initialize(params = nil)
    super(params)
    @user = find_user
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Speaker")
  end

  def persisted?
    @speaker.present? && @speaker.persisted?
  end

  private

  def persist!
    #begin
    @speaker = Speakers::CreateSpeakerService.instance.call(self)
    #rescue Exception => e
      #errors.add(:base, e.message)
    #end
  end

  def user_exists?
    @user.present?
  end

  def find_user
    User.where(email: @email).first
  end

end
