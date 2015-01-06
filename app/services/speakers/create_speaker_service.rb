module Speakers
  class CreateSpeakerService < BaseService

    def initialize(params)
      @params = params
    end

    def call
      @user = User.where(email: @params[:email]).first

      if @user
        if @user.speaker
          @speaker = @user.speaker
        else
          @speaker = Speaker.new(@params)
          @speaker.user = @user
        end
      else
        #Create user first
        password = Devise.friendly_token[0..7]
        @user = User.new(
            email: @params[:email],
            password: password
        )
        @user.save
        @speaker = Speaker.new(@params)
        @speaker.user = @user
        SpeakerMailer.new_speaker_mail(@speaker, @user, password).deliver
      end
      @speaker
    end
  end
end