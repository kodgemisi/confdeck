class ScheduleController < ApplicationController
  require 'json'

  def show
    @conference = Conference.find(params[:conference_id])
    @appeal_types = @conference.appeal_types.includes(:appeals).where("appeals.state" => "accepted")
    @room = Room.new
    @slot = Slot.new
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
