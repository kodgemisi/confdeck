module Speakers
  class CreateSpeakerService < BaseService

    def call(speaker_form)
      @speaker_form = speaker_form

      @user = @speaker_form.user

      if @user
        if @user.speaker
          @speaker = @user.speaker
        else
          @speaker = create_speaker
          @speaker.user = @user
        end
      else
        #Create user first
        password = Devise.friendly_token[0..7]
        @user = User.new(
            email: @speaker_form.email,
            password: password
        )
        ActiveRecord::Base.transaction do
          @speaker = create_speaker
          if @user.save
            @speaker.user = @user
            SpeakerMailer.new_speaker_mail(@speaker, @user, password).deliver
          else
            @speaker.errors.messages.merge @user.errors.messages
          end
        end
      end
      @speaker.save
      @speaker
    end

    def create_speaker
      Speaker.new(@speaker_form.attributes.except(:email))
    end
  end
end