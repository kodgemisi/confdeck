require 'spec_helper'

describe QuickSignupService  do

  it "creates user and conference wizard and returns user" do
    params = {
        email: "demo@example.com",
        password: "thestrongest",
        name: "RailsConf"
    }
    user = QuickSignupService.instance.call(params)
    expect(user).to be_a(User)
    expect(user).to eq(User.last)
    expect(user.email).to eq(params[:email])
    expect(user.conference_wizard).not_to be_nil
    expect(user.conference_wizard).to eq(ConferenceWizard.last)
  end

end