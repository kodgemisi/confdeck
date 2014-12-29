class ConferencePolicy < ApplicationPolicy
  def dashboard?
    @user.is_admin_of?(@record) || @user.is_user_of?(@record)
  end

  def manage?
    @user.is_admin_of? @record
  end

  def create?
    @user.is? "user"
  end
end