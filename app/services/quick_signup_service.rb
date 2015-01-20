class QuickSignupService < BaseService
  def call(params)
    user = User.new(
        email: params[:email],
        password: params[:password]
    )
    conference_wizard = ConferenceWizard.new_with_name(params[:name])

    ActiveRecord::Base.transaction do
      user.save!
      conference_wizard.user = user
      conference_wizard.save!
      return user
    end

  end
end