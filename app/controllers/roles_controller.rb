class RolesController < ApplicationController
  before_filter :set_conference

  def index

  end

  def create

  end

  private

  def roles_params
    params.permit(:confadmins, :confusers)
  end

  def set_conference
    @conference = Conference.friendly.find(params[:conference_id])
  end
end