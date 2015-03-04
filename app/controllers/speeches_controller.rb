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

class SpeechesController < ApplicationController
  include Activitable
  before_filter :authenticate_user!
  before_filter :set_speech, only: [:show, :edit, :update]
  #after_filter :create_action_activity, only: [:create, :comment, :upvote, :downvote, :accept, :reject]

  # GET /speeches
  # GET /speeches.json
  def index
    @speeches = current_user.speeches
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /speeches/1
  # GET /speeches/1.json
  def show
    authorize @speech, :see?

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @speech }
    end
  end

  # GET /speeches/1/edit
  def edit
    authorize @speech, :edit?
    @conference = @speech.conference
    respond_to do |format|
      format.html {render template: "shared/speeches/edit"}
    end
  end

  # PUT /speeches/1
  # PUT /speeches/1.json
  def update
    authorize @speech, :edit?
    respond_to do |format|
      if @speech.update_attributes(speech_params)
        format.html { redirect_to speeches_path, notice: 'Speech was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  private

  def set_speech
    @speech = Speech.find(params[:id])
  end

  def speech_params
    params.require(:speech).permit(:speech_type_id, topic_attributes: [:id, :subject, :abstract, :detail, :additional_info, speaker_ids: []])
  end

end
