class ScheduleController < ApplicationController
  require 'json'

  def show
    @conference = Conference.find(params[:conference_id])
    @appeal_types = @conference.appeal_types.includes(:appeals).where("appeals.state" => "accepted")
    @room = Room.new
    @slot = Slot.new
  end

  def appeal_list
    @conference = Conference.find(params[:conference_id])
    @appeal_types = @conference.appeal_types.includes(:appeals).where("appeals.state" => "accepted")

    respond_to do |format|
      format.html { render partial:"schedule/appeal_list", locals: {appeal_types: @appeal_types} }
    end
  end

  def update
    @slot = Slot.find(params["id"])

    attributes = {
        room_id: params["room_id"],
        start_time: params["start"],
        end_time: params["end"],

    }

    respond_to do |format|
      if @slot.update_attributes attributes
        format.json { head :no_content }
      else
        format.json { head :no_content }
      end
    end
  end

  def destroy
    @slot = Slot.find(params[:id])
    @slot.destroy

    respond_to do |format|
      format.html { redirect_to conferences_url }
      format.json { head :no_content }
    end
  end

  def create
    @conference = Conference.find(params[:conference_id])

    attributes = {
        room_id: params["room_id"],
        start_time: DateTime.parse(params["start"]),
        end_time: DateTime.parse(params["end"]),
        appeal_id: params["appeal_id"]

    }

    @slot = Slot.new
    @slot.attributes = attributes
    @day = Day.where("date BETWEEN ? AND ? ", @slot.start_time.to_date, @slot.end_time.to_date + 1.day).first
    @slot.day = @day
    @slot.conference = @conference
    respond_to do |format|
      if @slot.save
        format.json { head :no_content }
      else
        format.json { render json: @slot.errors, status: :unprocessable_entity }
      end
    end
  end
end
