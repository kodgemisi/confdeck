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

class Admin::RoomsController < Admin::AdminController
  before_filter :authenticate_user!

  before_filter :set_conference
  before_filter :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = @conference.rooms

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rooms }
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/new
  # GET /rooms/new.json
  def new
    @room = @conference.rooms.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    @room.conference_id = @conference.id

    respond_to do |format|
      if @room.save
        format.html { redirect_to admin_schedule_path, notice: 'Room was successfully created.' }
        format.json { render json: @room, status: :created, location: @room }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
        format.js

      end
    end
  end

  # PUT /rooms/1
  # PUT /rooms/1.json
  def update

    respond_to do |format|
      if @room.update_attributes(room_params)
        format.html { redirect_to ["admin", @room], notice: 'Room was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy

    respond_to do |format|
      format.html { redirect_to conference_rooms_url(@conference) }
      format.json { head :no_content }
    end
  end

  private

  def set_conference
    @conference = @current_conference
  end

  def set_room
    @room = @conference.rooms.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:conference_id, :name)
  end
end
