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
         :recoverable, :rememberable, :trackable, :validatable
  after_create :set_default_settings

  has_and_belongs_to_many :organizations
  has_many :conferences, through: :organizations
  has_one :conference_wizard #, -> { order("created_at DESC") }

  acts_as_voter

  serialize :settings



  def avatar_url(size=150)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def display_name
    email
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
end
