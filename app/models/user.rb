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

class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  enum role: [:user,  :admin]
  before_create :set_default_settings

  has_and_belongs_to_many :organizations
  has_many :conference_roles
  has_many :conferences, through: :conference_roles
  has_one :conference_wizard #, -> { order("created_at DESC") }
  has_one :speaker
  has_many :speeches, through: :speaker
  has_many :notifications
  acts_as_voter

  serialize :settings

  #for oauth
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update


  def avatar_url(size=150)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def display_name
    if speaker
      speaker.display
    else
      email
    end
  end

  def set_default_settings
    self.settings = {
        language: "en"
    } if self.settings.nil?

  end

  def set!(key, val)
    self.settings ||= {}
    self.settings[key] = val
  end

  def is?(role)
    self.role == role
  end

  def is_admin_of?(conference)
    conference_roles.where(conference: conference, role: ConferenceRole.roles[:confadmin]).first.present?
  end

  def is_user_of?(conference)
    conference_roles.where(conference: conference, role: ConferenceRole.roles[:confuser]).first.present?
  end


  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified || auth.provider == "google_oauth2" || auth.provider == "github"

      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20]
        )
        #user.skip_confirmation! #TODO will be enabled if confirmable
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.token = auth.credentials.token if auth.credentials.token
      identity.secret = auth.credentials.secret if auth.credentials.secret
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
