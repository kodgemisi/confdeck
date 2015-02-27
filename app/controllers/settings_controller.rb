class SettingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :populate_options
  before_action :set_defaults
  before_action :load_user, only: [:index, :update]
  def index

  end

  def update
    if params["user"].present? #updating account details
      resource = current_user
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      if resource.update_with_password(account_update_params)
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
        sign_in "user", resource, :bypass => true
        respond_to do |format|
          format.html { redirect_to settings_path, :flash => { :success => t(flash_key) } }
        end
      else
        resource.clean_up_passwords
        @resource = resource
        render 'index'
      end
    else # updating user settings
      current_user.update_attribute('settings', settings_params.to_hash)
      redirect_to settings_path
    end
  end


  def set_defaults
    @defaults = {
        language: "en"
    }
  end

  def populate_options
    @options = {
        language: [
            ["Türkçe","tr"],
            ["English","en"]
        ]
    }
  end

  def load_user
    @user = current_user
    @user_settings = current_user.settings
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def settings_params
    params.require(:settings)
  end

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
        resource.pending_reconfirmation? &&
        previous != resource.unconfirmed_email
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
