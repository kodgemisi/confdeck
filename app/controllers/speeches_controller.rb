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
  before_filter :authenticate_user!
  before_filter :set_conference
  before_filter :set_speech, only: [:show, :edit, :update, :destroy, :comment, :upvote, :downvote, :accept, :reject, :send_accept_mail, :send_reject_mail]
  after_filter :create_action_activity, only: [:create, :comment, :upvote, :downvote, :accept, :reject]

  # GET /speeches
  # GET /speeches.json
  def index
    @speech_types = @conference.speech_types.includes(:speeches)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @speech_types }
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

  # GET /speeches/new
  # GET /speeches/new.json
  def new
    @speech = Speech.new
    @speech.build_topic

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @speech }
      format.js
    end
  end

  # GET /speeches/1/edit
  def edit
  end

  # POST /speeches
  # POST /speeches.json
  def create
    @speech = Speech.new(speech_params)
    @speech.conference = @conference
    @speech.state = "accepted"
    respond_to do |format|
      if @speech.save
        if params[:add_another]
          format.html { redirect_to new_conference_speech_path(@conference), notice: 'Speech was successfully created.' }
        else
          format.html
        end
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /speeches/1
  # PUT /speeches/1.json
  def update
    respond_to do |format|
      if @speech.update_attributes(speech_params)
        format.html { redirect_to [@conference, @speech], notice: 'Speech was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @speech.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /speeches/1
  # DELETE /speeches/1.json
  def destroy
    @speech.destroy

    respond_to do |format|
      format.html { redirect_to conference_speeches_path(@conference) }
      format.json { head :no_content }
    end
  end

  def comment
    authorize @conference, :user?
    @comment = @speech.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to [@conference, @speech], notice: "Your comment is successfully created"}
      else
        format.html { render :action => 'show' }
      end
      format.js
    end

  end

  def upvote
    authorize @conference, :user?
    @speech.upvote_from current_user
    respond_to do |format|
      format.js
      format.html { redirect_to conference_speeches_path(@conference), notice: "This speech is upvoted" }
    end
  end

  def downvote
    @speech.downvote_from current_user
    respond_to do |format|
      format.js
      format.html { redirect_to conference_speeches_path(@conference), notice: "This speech is downvoted" }
    end
  end

  def accept
    authorize @conference, :manage?
    @speech.accept
    respond_to do |format|
      format.html { redirect_to conference_speech_path(@conference, @speech), notice: t("speeches.is_accepted") }
    end
  end

  def reject
    authorize @conference, :manage?
    @speech.reject
    respond_to do |format|
      format.html { redirect_to conference_speech_path(@conference, @speech), notice: t("speeches.is_rejected") }
    end
  end

  def send_accept_mail
    authorize @conference, :manage?
    SpeechMailer.accept_notification_email(@speech).deliver
    respond_to do |format|
      format.html { redirect_to conference_speech_path(@conference, @speech), notice: t("speeches.accept_mail_sent") }
    end
  end

  def send_reject_mail
    authorize @conference, :manage?
    SpeechMailer.reject_notification_email(@speech).deliver
    respond_to do |format|
      format.html { redirect_to conference_speech_path(@conference, @speech), notice: t("speeches.reject_mail_sent") }
    end
  end

  private

  def create_action_activity
    action = "speech_" + self.action_name
    activity = @speech.conference.activities.new
    activity.action = action
    activity.user = current_user

    if action == "speech_comment"
      activity.subject = @comment
    else
      activity.subject = @speech
    end
    activity.save
  end

  def set_conference
    @conference = Conference.friendly.find(params[:conference_id])
  end

  def set_speech
    @speech = @conference.speeches.find(params[:id])
  end

  def speech_params
    params.require(:speech).permit(:speech_type_id, topic_attributes: [:subject, :abstract, :detail, :additional_info, speaker_ids: []])
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
