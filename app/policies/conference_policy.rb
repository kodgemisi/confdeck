class ConferencePolicy < ApplicationPolicy
  def user?
    @user.is_admin_of?(@record) || @user.is_user_of?(@record)
  end

  def manage?
    @user.is_admin_of? @record
  end

  def create?
    @user.present?
  end

  def new?
    @user.present?
  end
end