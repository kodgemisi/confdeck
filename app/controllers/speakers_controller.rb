class SpeakersController < ApplicationController
  # GET /speakers
  # GET /speakers.json
  def index
    @speakers = Speaker.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @speakers }
    end
  end

  # GET /speakers/1
  # GET /speakers/1.json
  def show
    @speaker = Speaker.find(params[:id])

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
    @speaker = Speaker.find(params[:id])
  end

  # POST /speakers
  # POST /speakers.json
  def create
    @speaker = Speaker.new(params[:speaker])

    respond_to do |format|
      if @speaker.save
        format.html { redirect_to @speaker, notice: 'Speaker was successfully created.' }
        format.json { render json: @speaker, status: :created, location: @speaker }
      else
        format.html { render action: "new" }
        format.json { render json: @speaker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /speakers/1
  # PUT /speakers/1.json
  def update
    @speaker = Speaker.find(params[:id])

    respond_to do |format|
      if @speaker.update_attributes(params[:speaker])
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
    @speaker = Speaker.find(params[:id])
    @speaker.destroy

    respond_to do |format|
      format.html { redirect_to speakers_url }
      format.json { head :no_content }
    end
  end
end
