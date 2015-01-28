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

class SpeakersController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create]
  before_action :set_speaker, only: [:show, :edit, :update, :destroy]
  # GET /speakers
  # GET /speakers.json
  def index
    @speakers = Speaker.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @speakers }
    end
  end

  # GET /speakers/1
  # GET /speakers/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @speaker }
    end
  end

  # GET /speakers/new
  # GET /speakers/new.json
  def new
    @speaker = Speaker.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @speaker }
    end
  end

  # GET /speakers/1/edit
  def edit
  end

  # POST /speakers
  # POST /speakers.json
  def create
    #check if speaker exists in db
    #@speaker = Speakers::CreateSpeakerService.call(speaker_params)
    @speaker = SpeakerForm.new(speaker_params)

    @speaker = @speaker.speaker if @speaker.save

    respond_to do |format|
      format.js
    end
  end

  # PUT /speakers/1
  # PUT /speakers/1.json
  def update
    respond_to do |format|
      if @speaker.update_attributes(speaker_params)
        format.html { redirect_to @speaker, notice: 'Speaker was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @speaker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /speakers/1
  # DELETE /speakers/1.json
  def destroy
    @speaker.destroy

    respond_to do |format|
      format.html { redirect_to speakers_url }
      format.json { head :no_content }
    end
  end

  private
    def set_speaker
      @speaker = Speaker.find(params[:id])
    end

    def speaker_params
      params.require(:speaker).permit(:name, :phone, :twitter, :facebook, :email)
    end
end
