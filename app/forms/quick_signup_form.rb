class QuickSignupForm < BaseForm
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  attr_accessor :user
  attr_accessor :conference

  attribute :name, String
  attribute :email, String
  attribute :password, String

  validates :email, presence: true, format: { :with => VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :password, presence: true
  validate :verify_unique_email


  private
    def persist!
      self.user = QuickSignupService.instance.call(self)
    end

    def verify_unique_email
      if User.exists? email: email
        errors.add :email, "has already been taken"
      end
    end
end