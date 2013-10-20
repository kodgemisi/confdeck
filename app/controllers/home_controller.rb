class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :guest_session]

  layout "home_layout", :only => [:index]

  def index
    @days = Day.joins(:conferences).where('date > ?', Date.today).order("date DESC").group("conferences.id")
    @conferences = Conference.includes(:days).order('days.date ').where('days.date > ?', Date.today).group("conferences.id").limit(5)

  end

  def dashboard
  end

  def guest_session
    user = User.where(email: "guest@kodgemisi.com").first
    sign_in user, :bypass => true
    redirect_to root_url
  end
end
