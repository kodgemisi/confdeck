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
  before_filter :authenticate_user!, except: [:index, :guest_session]

  layout "home_layout", :only => [:index]

  def index
    
  end

  def dashboard
    @conferences = current_user.conferences.includes(:days).order('days.date ').where('days.date > ?', Date.today).limit(5).distinct
    @waiting_speeches = Speech.where(:conference_id => current_user.conferences.pluck(:id), :state => "waiting_review")
    @total_speeches = Speech.where(:conference_id => current_user.conferences.pluck(:id))
    @activities = Activity.where(conference_id: [ current_user.conferences.pluck(:id)]).order("created_at DESC").limit(15)
  end

end
