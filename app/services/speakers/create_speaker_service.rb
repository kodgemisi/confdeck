
module Speakers
  class CreateSpeakerService < BaseService

    def self.call(params)
      @params = params
      @user = User.where(email: @params[:user][:email]).first

      if @user
        if @user.speaker
          @speaker = @user.speaker
        else
          @speaker = Speaker.new(@params.except(:user))
          @speaker.user = @user
        end
      else
        #Create user first
        password = Devise.friendly_token[0..7]
        @user = User.new(
            email: @params[:user][:email],
            password: password
        )
        ActiveRecord::Base.transaction do
          @speaker = Speaker.new(@params.except(:user))
          if @user.save
            @speaker.user = @user
            SpeakerMailer.new_speaker_mail(@speaker, @user, password).deliver
          else
            @speaker.errors.messages.merge @user.errors.messages
          end
        end
      end
      @speaker
    end
  end
end