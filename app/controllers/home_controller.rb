class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:index]

  layout "home_layout", :only => [:index]

  def index
    @days = Day.joins(:conferences).where('date > ?', Date.today).order("date DESC").group("conferences.id")
    @conferences = Conference.includes(:days).order('days.date ').where('days.date > ?', Date.today).group("conferences.id").limit(5)

  end

  def dashboard
  end
end
