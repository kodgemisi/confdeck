class Admin::AdminController < ApplicationController
  layout "admin_layout"

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
end