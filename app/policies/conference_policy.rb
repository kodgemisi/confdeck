class ConferencePolicy < ApplicationPolicy
  def manage?
    @user.is_admin_of? @record
  end

  def create?
    @user.is? "user"
  end
end