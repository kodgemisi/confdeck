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

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user_data
  before_filter :set_locale
  layout :layout_for_devise

  protected

  def layout_for_devise
    if devise_controller?
      "application_no_nav"
    else
      "application"
    end
  end

  def set_locale
    if current_user
      I18n.locale = current_user.settings[:language]
    else
      #TODO: we should get locale from user agent
      I18n.locale = I18n.default_locale
    end

  end


  # to make accessible across all controllers to use on sidebar
  def set_user_data
    if current_user
      @user_conferences = current_user.conferences.includes(:waiting_appeals) #waiting appeals for display count on sidebar
      @user_organizations = current_user.organizations
    end
  end
end
