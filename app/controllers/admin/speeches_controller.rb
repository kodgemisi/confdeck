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

class Admin::SpeechesController < Admin::AdminController
  include Activitable
  before_filter :authenticate_user!
  before_filter :set_conference
  before_filter :set_speech, only: [:show, :edit, :update, :destroy, :comment, :upvote, :downvote, :accept, :reject, :send_accept_mail, :send_reject_mail]
  #after_filter :create_action_activity, only: [:create, :comment, :upvote, :downvote, :accept, :reject]

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

  #TODO service implementation
  # POST /speeches
  # POST /speeches.json
  def create
    authorize @conference, :manage?
    Speech.transaction do
      @speech = Speech.new(speech_params)
      @speech.conference = @conference
      @speech.state = "accepted"
      create_activity!(current_user, @conference, @speech, "speech_new")
    end
    respond_to do |format|
      if @speech.save
        if params[:add_another]
          format.html { redirect_to new_admin_speech_path, notice: 'Speech was successfully created.' }
        else
          format.html { redirect_to admin_speech_path(@speech), notice: 'Speech was successfully created.' }
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
        format.html { redirect_to ["admin", @speech], notice: 'Speech was successfully updated.' }
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
      format.html { redirect_to admin_speeches_path }
      format.json { head :no_content }
    end
  end

  #TODO service implementation
  def comment
    authorize @conference, :user?
    Speech.transaction do
      @comment = @speech.comments.build(comment_params)
      @comment.user = current_user
      create_activity!(current_user, @conference, @speech, "speech_comment")
    end

    respond_to do |format|
      if @comment.save
        format.html { redirect_to ["admin", @speech], notice: "Your comment is successfully created"}
      else
        format.html { render :action => 'show' }
      end
      format.js
    end

  end

  def upvote
    authorize @conference, :user?
    Speech.transaction do
      @speech.upvote_from current_user
      create_activity!(current_user, @conference, @speech, "speech_upvote")
    end

    respond_to do |format|
      format.js
      format.html { redirect_to admin_speeches_path, notice: "This speech is upvoted" }
    end
  end

  def downvote
    authorize @conference, :user?
    Speech.transaction do
      @speech.downvote_from current_user
      create_activity!(current_user, @conference, @speech, "speech_downvote")
    end
    respond_to do |format|
      format.js
      format.html { redirect_to admin_speeches_path, notice: "This speech is downvoted" }
    end
  end

  def accept
    authorize @conference, :manage?
    Speech.transaction do
      @speech.accept!
      create_activity!(current_user, @conference, @speech, "speech_accept")
    end
    respond_to do |format|
      format.html { redirect_to admin_speech_path(@speech) }
    end
  end

  def reject
    authorize @conference, :manage?
    Speech.transaction do
      @speech.reject!
      create_activity!(current_user, @conference, @speech, "speech_reject")
    end
    respond_to do |format|
      format.html { redirect_to admin_speech_path(@speech) }
    end
  end

  def send_accept_mail
    authorize @conference, :manage?
    SpeechMailer.accept_notification_email(@speech).deliver
    respond_to do |format|
      format.html { redirect_to admin_speech_path(@speech) }
    end
  end

  def send_reject_mail
    authorize @conference, :manage?
    SpeechMailer.reject_notification_email(@speech).deliver
    respond_to do |format|
      format.html { redirect_to admin_speech_path(@speech) }
    end
  end

  private

  def set_conference
    @conference = @current_conference
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
