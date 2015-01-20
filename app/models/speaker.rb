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

class Speaker < ActiveRecord::Base
  has_and_belongs_to_many :topics
  has_many :speeches, through: :topics
  belongs_to :user
  validates_presence_of :name, :phone
  #TODO refactor
  #attr_accessor :email

  def avatar_url(size=150)
    gravatar_id = Digest::MD5::hexdigest(self.user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def info
    "#{self.name}"
  end

  def display
    "#{self.name}"
  end

  def to_liquid
    {
        'name' => name,
        'bio' => bio,
        'github' => github,
        'twitter' => twitter,
        'facebook' => facebook,
        'email' => email,
        'phone' => phone,
    }
  end
end
