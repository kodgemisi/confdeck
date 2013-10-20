class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:index]

  layout "home_layout", :only => [:index]

  def index
  end

  def dashboard

  end
end
