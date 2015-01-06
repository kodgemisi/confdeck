class SpeechPolicy < ApplicationPolicy
  def manage?
    @user.is_admin_of?(@record.conference) || @record.topic.speakers.collect(&:user).include?(User.first)
  end

  def see?
    @user.is_admin_of?(@record.conference) || @user.is_user_of?(@record.conference) || @record.topic.speakers.collect(&:user).include?(User.first)
  end
end