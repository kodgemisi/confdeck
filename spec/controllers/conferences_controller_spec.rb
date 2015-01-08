require 'rails_helper'

RSpec.describe ConferencesController do
  before :each do
    @user = Fabricate(:user)
    sign_in @user
  end

  describe "GET index" do
    it "assigns current_user's conferences to @conferences" do
      conference = Fabricate(:conference, conference_admins: [@user])
      get :index
      expect(assigns(:conferences)).to eq([conference])
    end

    it "doesnt assign other user's conferences to @conferences" do
      conference = Fabricate(:conference, conference_admins: [Fabricate(:user)])
      get :index
      expect(assigns(:conferences)).not_to eq([conference])
    end
  end

end