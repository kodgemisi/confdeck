require 'spec_helper'

describe Speakers::CreateSpeakerService  do

  it "returns speaker if it exists" do
    @speaker = Fabricate(:speaker)
    speaker_form = SpeakerForm.new({
            email: @speaker.user.email
    })

    @response = Speakers::CreateSpeakerService.instance.call(speaker_form)
    expect(@response.id).to eq @speaker.id
  end

  it "creates speaker for user if it doesn't exist" do
    @user = Fabricate(:user)
    speaker_form = SpeakerForm.new({
         email: @user.email
     })

    @response = Speakers::CreateSpeakerService.instance.call(speaker_form)
    expect(@response.user.id).to eq @user.id
  end

  it "creates user and speaker if it doesn't exist" do
    mail = ActionMailer::Base.deliveries.count
    @speaker = Fabricate.build(:speaker)

    speaker_form = SpeakerForm.new({
      email: @speaker.user.email,
      name: @speaker.name,
      phone: @speaker.phone
     })

    @response = Speakers::CreateSpeakerService.instance.call(speaker_form)
    @response.save
    expect(User.find_by(email: @speaker.user.email)).not_to be_nil
    expect( ActionMailer::Base.deliveries.count ).to eq(mail+1)
  end
end