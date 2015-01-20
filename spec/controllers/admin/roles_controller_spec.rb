require 'rails_helper'

RSpec.describe Admin::RolesController do


  before :all do
    @user = Fabricate(:user)
  end

  before :each do
    sign_in @user
    @conference = Fabricate(:conference)
    @request.host = "#{@conference.slug}.example.com"

  end


  describe "POST create" do
    it "redirects to conference url for unauthorized user" do
      post :create, {}
      expect(response).to redirect_to(conference_url(subdomain: @conference.slug))
    end

    it "redirects to conference admin url for conference user" do
      @conference.conference_users << @user
      post :create, {}
      expect(response).to redirect_to(admin_conference_path)
    end

    it "updates roles for conference user" do
      @conference.conference_admins << @user
      @user2 = Fabricate(:user)
      @user3 = Fabricate(:user)
      @user4 = Fabricate(:user)

      post :create, {conference_admins: [@user.id, @user3.id, @user2.id], conference_users: [@user4.id]}
      expect(response).to redirect_to(admin_roles_path)
      @conference.reload
      expect(@conference.conference_admins.ids).to include(@user2.id)
      expect(@conference.conference_admins.ids).to include(@user3.id)
      expect(@conference.conference_users.ids).to include(@user4.id)

      expect(@conference.conference_users.ids).not_to include(@user2.id)
      expect(@conference.conference_users.ids).not_to include(@user3.id)
      expect(@conference.conference_admins.ids).not_to include(@user4.id)

    end
  end




end