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

class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :quick_signup]

  layout "landing_layout", :only => [:index]

  def index
    @signup_form = QuickSignupForm.new(user: User.new, conference: Conference.new)
  end

  def dashboard
    @conferences = current_user.conferences.includes(:days).order('days.date ').where('days.date > ?', Date.today).limit(5).distinct
    @waiting_speeches = Speech.where(:conference_id => current_user.conferences.pluck(:id), :state => "waiting_review")
    @total_speeches = Speech.where(:conference_id => current_user.conferences.pluck(:id))
    @activities = Activity.where(conference_id: [ current_user.conferences.pluck(:id)]).order("created_at DESC").limit(15)
  end

  def quick_signup
    signup = QuickSignupForm.new(quick_signup_params)
    respond_to do |format|
      if signup.save
        sign_in(signup.user)
        format.html { redirect_to new_conferences_path }
      else
        format.html { render text: signup.errors.full_messages.to_s }
      end
    end
  end

  private

  def quick_signup_params
    params.require(:quick_signup_form).permit(:email, :password, :name)
  end
end
