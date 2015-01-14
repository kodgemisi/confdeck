class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!
  layout "admin_layout"
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_filter :set_current_conference

  attr_accessor :current_conference

  def set_current_conference
    subdomain = request.subdomain
    black_list = ["", "www"]
    unless black_list.include?(subdomain)
      conference = Conference.friendly.find(subdomain)
      if conference
        @current_conference = conference
      end
    end
  end

  private

    def user_not_authorized
      flash[:error] = t("general.not_authorized")
      redirect_to admin_conference_path
    end
end