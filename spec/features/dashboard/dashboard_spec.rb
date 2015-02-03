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

  context "" do
    before :all do
      @conference.conference_admins << @user
    end

    it "displays upcoming conferences" do
      visit(root_url)
      expect(page).to have_content(@conference.name)
    end
  end

end