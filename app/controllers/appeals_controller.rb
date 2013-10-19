class AppealsController < ApplicationController
  before_filter :set_conference
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
    @appeal = Appeal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appeal }
    end
  end

  # GET /appeals/new
  # GET /appeals/new.json
  def new
    @appeal = Appeal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appeal }
    end
  end

  # GET /appeals/1/edit
  def edit
    @appeal = Appeal.find(params[:id])
  end

  # POST /appeals
  # POST /appeals.json
  def create
    @appeal = Appeal.new(params[:appeal])

    respond_to do |format|
      if @appeal.save
        format.html { redirect_to @appeal, notice: 'Appeal was successfully created.' }
        format.json { render json: @appeal, status: :created, location: @appeal }
      else
        format.html { render action: "new" }
        format.json { render json: @appeal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /appeals/1
  # PUT /appeals/1.json
  def update
    @appeal = Appeal.find(params[:id])

    respond_to do |format|
      if @appeal.update_attributes(params[:appeal])
        format.html { redirect_to @appeal, notice: 'Appeal was successfully updated.' }
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
    @appeal = Appeal.find(params[:id])
    @appeal.destroy

    respond_to do |format|
      format.html { redirect_to appeals_url }
      format.json { head :no_content }
    end
  end

  private
  def set_conference
    @conference = Conference.find(params[:conference_id])
  end
end
