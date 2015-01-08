require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Conference Dashboard", :type => :feature do

  before :all do
    @user = Fabricate(:user)
    @user.set!("language", "en")
    login_as(@user, :scope => :user)
    @conference = Fabricate(:conference)
    @organization = @conference.organizations.first
    @user.organizations << @organization
    I18n.locale = :en
  end

  context "activity feed" do
    it "displays no activity text when empty" do
      visit(manage_conference_path(@conference))
      expect(page).to have_content(I18n.t("conferences.no_activity"))
    end
  end

end