class SponsorsController < ApplicationController
  before_filter :authenticate_user!

  before_filter :set_conference

  # GET /sponsors
  # GET /sponsors.json
  def index
    @sponsors = @conference.sponsors

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sponsors }
    end
  end

  # GET /sponsors/1
  # GET /sponsors/1.json
  def show
    @sponsor = @conference.sponsors.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sponsor }
    end
  end

  # GET /sponsors/new
  # GET /sponsors/new.json
  def new
    @sponsor = @conference.sponsors.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sponsor }
    end
  end

  # GET /sponsors/1/edit
  def edit
    @sponsor = @conference.sponsors.find(params[:id])
  end

  # POST /sponsors
  # POST /sponsors.json
  def create
    @sponsor = @conference.sponsors.new(params[:sponsor])

    respond_to do |format|
      if @sponsor.save
        format.html { redirect_to [@conference, @sponsor], notice: 'Sponsor was successfully created.' }
        format.json { render json: @sponsor, status: :created, location: @sponsor }
      else
        format.html { render action: "new" }
        format.json { render json: @sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sponsors/1
  # PUT /sponsors/1.json
  def update
    @sponsor = Sponsor.find(params[:id])

    respond_to do |format|
      if @sponsor.update_attributes(params[:sponsor])
        format.html { redirect_to [@conference, @sponsor], notice: 'Sponsor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sponsors/1
  # DELETE /sponsors/1.json
  def destroy
    @sponsor = Sponsor.find(params[:id])
    @sponsor.destroy

    respond_to do |format|
      format.html { redirect_to sponsors_url }
      format.json { head :no_content }
    end
  end

  private

  def set_conference
    @conference = Conference.find(params[:conference_id])
  end
end
