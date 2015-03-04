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
  include Pundit
  protect_from_forgery
  before_filter :set_user_data
  before_filter :set_locale
  layout :layout_for_devise
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    if session[:conference_name]
      wizard = ConferenceWizard.new_with_name(session[:conference_name])
      wizard.user = resource
      wizard.save
      session.delete(:conference_name)
      new_conferences_path
    else
      if is_conference?
        admin_conference_url
      else
        root_url
      end

    end
  end

  private

  def user_not_authorized
    flash[:error] = t("general.not_authorized")
    redirect_to root_path
  end

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
      I18n.locale = current_user.settings['language']
    else
      if I18n.locale_available? extract_locale.to_sym
        I18n.locale = extract_locale
      else
        I18n.locale = I18n.default_locale
      end
    end
  end

  def extract_locale
    return "en" if request.env['HTTP_ACCEPT_LANGUAGE'].nil?
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  # to make accessible across all controllers to use on sidebar
  def set_user_data
    if current_user
      @user_conferences = current_user.conferences
      @user_organizations = current_user.organizations
    end
    @admin = false
  end

  def is_conference?
    Subdomain.new.matches? request
  end
end
