require 'rails_helper'

describe "the signin process", :type => :feature do
  before :each do
    User.create(:email => 'user@example.com', :password => 'password')
  end

  it "signs me in" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => 'user@example.com'
      fill_in 'user_password', :with => 'password'
    end
    click_button I18n.t("user.login")
    expect(page).to have_content I18n.t("devise.sessions.signed_in")
  end
end
