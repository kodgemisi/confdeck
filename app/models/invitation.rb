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

class Invitation < ActiveRecord::Base
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
