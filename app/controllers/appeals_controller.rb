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

class AppealsController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create, :show]

  before_filter :set_conference
  before_filter :set_appeal, only: [:show, :edit, :update, :destroy, :comment, :upvote, :downvote, :accept, :reject]

  layout "application_no_nav", :only => ["new", "show"]
  # GET /appeals
  # GET /appeals.json
  def index
    @appeals = @conference.appeals

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @appeals }
    end
  end

  # GET /appeals/1
  # GET /appeals/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appeal }
    end
  end

  # GET /appeals/new
  # GET /appeals/new.json
  def new
    @appeal = Appeal.new
    @appeal.build_topic

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appeal }
    end
  end

  # GET /appeals/1/edit
  def edit
  end

  # POST /appeals
  # POST /appeals.json
  def create
    @appeal = Appeal.new(params[:appeal])
    @appeal.conference = @conference

    respond_to do |format|
      if @appeal.save
        format.html { redirect_to [@conference, @appeal], notice: 'Appeal was successfully created.' }
        format.json { render json: @appeal, status: :created, location: @appeal }
      else
        format.html { render layout: "application_no_nav",action: "new" }
        format.json { render json: @appeal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /appeals/1
  # PUT /appeals/1.json
  def update
    respond_to do |format|
      if @appeal.update_attributes(params[:appeal])
        format.html { redirect_to [@conference, @appeal], notice: 'Appeal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @appeal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appeals/1
  # DELETE /appeals/1.json
  def destroy
    @appeal.destroy

    respond_to do |format|
      format.html { redirect_to conference_appeals_path(@conference) }
      format.json { head :no_content }
    end
  end

  def comment
    @comment = @appeal.comments.build(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to [@conference, @appeal], notice: "Your comment is successfully created"}
      else
        format.html { render :action => 'show' }
      end
      format.js
    end

  end

  def upvote
    @appeal.upvote_from current_user
    respond_to do |format|
      format.html { redirect_to conference_appeals_path(@conference), notice: "This appeal is upvoted" }
    end
  end

  def downvote
    @appeal.downvote_from current_user
    respond_to do |format|
      format.html { redirect_to conference_appeals_path(@conference), notice: "This appeal is downvoted" }
    end
  end

  def accept
    @appeal.accept
    respond_to do |format|
      format.html { redirect_to conference_appeals_path(@conference), notice: "This appeal is accepted" }
    end
  end

  def reject
    @appeal.reject
    respond_to do |format|
      format.html { redirect_to conference_appeals_path(@conference), notice: "This appeal is rejected" }
    end
  end

  private
  def set_conference
    @conference = Conference.find(params[:conference_id])
  end

  def set_appeal
    @appeal = @conference.appeals.find(params[:id])
  end
end
