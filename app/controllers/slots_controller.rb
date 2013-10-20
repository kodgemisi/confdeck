class SlotsController < ApplicationController
  before_filter :authenticate_user!

  before_filter :set_conference
  before_filter :set_slot, only: [:show, :edit, :update, :destroy]

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
        format.html { redirect_to [@conference, @slot], notice: 'Slot was successfully created.' }
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
        format.html { redirect_to [@conference, @slot], notice: 'Slot was successfully updated.' }
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
      format.html { redirect_to conference_slots_url(@conference) }
      format.json { head :no_content }
    end
  end

  private

  def set_conference
    @conference = Conference.find(params[:conference_id])
  end

  def set_slot
    @slot = @conference.slots.find(params[:id])
  end
end
