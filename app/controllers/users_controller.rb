class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  layout "application_no_header"

  def show
    @speeches = @user.speeches 
  end

  private

  def set_user
    id = params[:id]

    if id.is_a? Integer
      @user = User.find_by(username: id)
    else
      @user = User.find(id)
    end
  end

end