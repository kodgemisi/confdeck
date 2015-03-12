require 'rails_helper'

describe Comment do
  before :each do
    @speech = Fabricate.create(:speech)
    @user = Fabricate.create(:user)
  end
  
  it "sends an email" do
    expect { Fabricate.create(:comment, commentable: @speech, user: @user) }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

end
