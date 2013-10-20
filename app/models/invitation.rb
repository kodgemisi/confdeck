class Invitation < ActiveRecord::Base
  attr_accessible :active, :email, :organization_id, :token

  before_save :generate_token

  validates_presence_of :email, :organization_id

  def generate_token
    raw, enc = Devise.token_generator.generate(self.class, :token)
    @raw_invitation_token = raw
    self.token = enc
  end

  def self.accept_invitation(token, user)
    @invitation = Invitation.where(token: token).first
    if @invitation.present? && @invitation.active?
      @invitation.active = false
      @invitation.save
      @organization = Organization.find(@invitation.organization_id)
      user.organizations << @organization unless @organization.users.include? user

      return true
    end
    return false
  end

end
