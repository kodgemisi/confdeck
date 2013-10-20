class RoomsController < ApplicationController
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
    @room = Room.new(params[:room])
    @room.conference_id = @conference.id

    respond_to do |format|
      if @room.save
        format.html { redirect_to schedule_conference_path(@conference), notice: 'Room was successfully created.' }
        format.json { render json: @room, status: :created, location: @room }
      else
        format.html { render action: "new" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rooms/1
  # PUT /rooms/1.json
  def update

    respond_to do |format|
      if @room.update_attributes(params[:room])
        format.html { redirect_to [@conference, @room], notice: 'Room was successfully updated.' }
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
    @conference = Conference.find(params[:conference_id])
  end

  def set_room
    @room = @conference.rooms.find(params[:id])
  end
end
