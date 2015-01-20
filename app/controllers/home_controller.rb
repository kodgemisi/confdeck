class HomeController < ApplicationController

  layout "home_layout", :only => [:index]

  def index

  end

  def dashboard
  end
end