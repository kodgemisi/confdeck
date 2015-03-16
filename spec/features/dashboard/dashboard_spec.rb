require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Confdeck Dashboard", :type => :feature do

  before :each do
    @user = Fabricate(:user)
    login_as(@user, :scope => :user)
    @conference = Fabricate(:conference)
  end

  context "" do
    before :each do
      @conference.conference_admins << @user
    end

    it "displays upcoming conferences" do
      visit(root_url)
      expect(page).to have_content(@conference.name)
      end

    it "can switch to conferences from navbar" do
      visit(root_url)
      expect(page).to have_link(I18n.t("general.switch_conference", conference: @conference.name), href: admin_conference_url(subdomain: @conference.slug))
    end
  end

end