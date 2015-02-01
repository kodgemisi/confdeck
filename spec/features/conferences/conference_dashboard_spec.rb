require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Conference Dashboard", :type => :feature do

  before :all do
    @user = Fabricate(:user)
    @user.set!("language", "en")
    login_as(@user, :scope => :user)
    @conference = Fabricate(:conference)
    I18n.locale = :en
  end

  before :each do
    sleep 3
    login_as(@user, :scope => :user)
  end


  context "admin" do
    before :all do
      @conference.conference_admins << @user
    end

    it "can click and go to speech list" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Speeches"
      expect(page).to have_content(I18n.t("titles.speeches.index", conference: @conference.name))
    end

    it "can click and go to schedule" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Schedule"
      expect(page).to have_content(I18n.t("titles.conferences.schedule", conference: @conference.name))
    end

    it "can click and go to roles" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Roles"
      expect(page).to have_content(I18n.t("titles.roles.index", conference: @conference.name))
    end


  end

end