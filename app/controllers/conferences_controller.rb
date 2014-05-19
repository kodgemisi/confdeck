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

class ConferencesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource

  layout 'conference_landing', :only => [:show]
  # GET /conferences
  # GET /conferences.json
  def index
    @conferences = current_user.conferences.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conferences }
    end
  end

  # GET /conferences/1
  # GET /conferences/1.json
  def show
    @conference = Conference.find(params[:id])
    @slot = Slot.new #for schedule showing


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conference }
    end
  end

  # GET /conferences/new
  # GET /conferences/new.json
  def new
    @conference = Conference.new
    @conference.build_address

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conference }
    end
  end

  # GET /conferences/1/edit
  def edit
    @conference = Conference.find(params[:id])
  end

  # POST /conferences
  # POST /conferences.json
  def create
    @conference = Conference.new(params[:conference])

    begin
      from_date = DateTime.strptime(@conference.from_date, I18n.t(:"date.formats.default"))
    rescue
    end
    begin
      to_date = DateTime.strptime(@conference.to_date, I18n.t(:"date.formats.default"))
    rescue
    end


    respond_to do |format|
      if @conference.save
        @conference.create_days(from_date, to_date)
        format.html { redirect_to @conference, notice: 'Conference was successfully created.' }
        format.json { render json: @conference, status: :created, location: @conference }
      else
        format.html { render action: "new" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conferences/1
  # PUT /conferences/1.json
  def update
    @conference = Conference.find(params[:id])

    if(params[:from] && params[:to])
     from_date = DateTime.strptime(params[:from], "%m/%d/%Y")
     to_date = DateTime.strptime(params[:to], "%m/%d/%Y")
    end
    respond_to do |format|
      if @conference.update_attributes(params[:conference])
        if (params[:from] && params[:to])
         @conference.days.destroy_all
         @conference.create_days(from_date, to_date)
        end
        format.html { redirect_to edit_conference_path(@conference), notice: 'Conference was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conferences/1
  # DELETE /conferences/1.json
  def destroy
    @conference = Conference.find(params[:id])
    @conference.destroy

    respond_to do |format|
      format.html { redirect_to conferences_url }
      format.json { head :no_content }
    end
  end

  def schedule
    @conference = Conference.find(params[:id])
    @room = Room.new
    @slot = Slot.new
  end

  def appeal_types
    @appeal_types = Conference.find(params[:id]).appeal_types
    respond_to do |format|
      format.json { render json: @appeal_types }
    end
  end

  #admin side #show equivalent
  def manage

  end
end
