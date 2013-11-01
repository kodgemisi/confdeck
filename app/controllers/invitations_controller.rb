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

class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  def accept
    @token = params[:invitation_token]

    respond_to do |format|
      if Invitation.accept_invitation(@token, current_user)
        format.html { redirect_to organizations_path, notice: 'You are now member of the organization.' }
      else
        format.html { redirect_to root_url, notice: 'Your invitation token is wrong.' }
      end
    end
  end
end
