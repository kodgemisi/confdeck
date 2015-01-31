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

    it "can click and go to Speeches" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Speeches"
      expect(page).to have_content(I18n.t("titles.speeches.index", conference: @conference.name))
    end

    it "can click and go to Schedule" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Schedule"
      expect(page).to have_content(I18n.t("titles.conferences.schedule", conference: @conference.name))
    end

    it "can click and go to Roles" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Roles"
      expect(page).to have_content(I18n.t("titles.roles.index", conference: @conference.name))
    end

    it "can click and go to Email Templates" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Email Templates"
      expect(page).to have_content(I18n.t("titles.conferences.email_templates"))
    end

    it "can click and go to Sponsors" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Sponsors"
      expect(page).to have_content(I18n.t("titles.sponsors.index", conference: @conference.name))
    end

    it "can click and go to Speech Types" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Speech Types"
      expect(page).to have_content(I18n.t("titles.conferences.speech_types", conference: @conference.name))
    end

    it "can click and go to Basic Information" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Basic Information"
      expect(page).to have_content(I18n.t("titles.conferences.basic_information", conference: @conference.name))
    end

    it "can click and go to Address" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Address"
      expect(page).to have_content(I18n.t("titles.conferences.address", conference: @conference.name))
    end

    it "can click and go to Contact Information" do
      visit(admin_conference_url(subdomain: @conference.slug))
      click_link "Contact Information"
      expect(page).to have_content(I18n.t("titles.conferences.contact_information", conference: @conference.name))
    end

  end

end