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

class Admin::SlotsController < Admin::AdminController
  before_filter :authenticate_user!

  before_filter :set_conference
  before_filter :set_slot, only: [:show, :edit, :update, :destroy]

  layout false

  # GET /slots
  # GET /slots.json
  def index
    @slots = @conference.slots

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @slots }
    end
  end

  # GET /slots/1
  # GET /slots/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @slot }
    end
  end

  # GET /slots/new
  # GET /slots/new.json
  def new
    @slot = @conference.slots.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @slot }
    end
  end

  # GET /slots/1/edit
  def edit
  end

  # POST /slots
  # POST /slots.json
  def create
    @slot = @conference.slots.new(params[:slot])

    respond_to do |format|
      if @slot.save
        format.html { redirect_to schedule_conference_path(@conference), notice: 'Slot was successfully created.' }
        format.json { render json: @slot, status: :created, location: @slot }
      else
        format.html { render action: "new" }
        format.json { render json: @slot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /slots/1
  # PUT /slots/1.json
  def update
    respond_to do |format|
      if @slot.update_attributes(params[:slot])
        format.html { redirect_to schedule_conference_path(@conference), notice: 'Slot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @slot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slots/1
  # DELETE /slots/1.json
  def destroy
    @slot.destroy

    respond_to do |format|
      format.html { redirect_to schedule_conference_path(@conference) }
      format.json { head :no_content }
    end
  end

  private

  def set_conference
    @conference = @current_conference
  end

  def set_slot
    @slot = @conference.slots.find(params[:id])
  end
end
