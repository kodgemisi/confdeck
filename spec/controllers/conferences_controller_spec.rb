require 'rails_helper'

RSpec.describe ConferencesController do
  # Create valid attributes for post
  def valid_attributes
    {
        from_date: "07/01/2015",
        to_date: "10/02/2015",
        name: "Dedecon",
        summary: "Facere voluptatem et ut voluptas",
        description: "Sapiente et modi molestias. Nemo dolore possimus doloribus. Sint quas delectus nihil debitis blanditiis dolor reprehenderit.",
        email: "selam@dedeler.com",
        organization_ids: [Fabricate(:organization).id],
        speech_types_attributes: {
            '0' => {type_name: "Workshop"}
        }
    }
  end

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

  describe "POST create" do
    describe "with valid params" do
      it "creates a new conference" do
        expect do
          post :create, { conference: valid_attributes }
        end.to change(Conference, :count).by(1)
      end

      it "assigns a newly created conference to @conference" do
        post :create, { conference: valid_attributes }
        expect(assigns(:conference)).to be_a(Conference)
        expect(assigns(:conference)).to be_persisted
      end

      it "assigns organizations to new conference" do
        post :create, { conference: valid_attributes }
        conference = assigns(:conference)
        expect(conference.organizations).not_to be_empty
      end

      it "assigns speech types to new conference" do
        post :create, { conference: valid_attributes }
        conference = assigns(:conference)
        expect(conference.speech_types.first.type_name).to eq("Workshop")
      end

      it "assigns current user as conference admin to new conference" do
        post :create, { conference: valid_attributes }
        conference = assigns(:conference)
        expect(conference.conference_admins).to eq([@user])
      end

      it "redirects to deck of new conference" do
        pending
        post :create, { conference: valid_attributes }
        expect(response).to redirect_to manage_conference_path(Conference.last)
      end
    end


    describe "with invalid params" do
      it "returns an unsaved new conference" do
        allow_any_instance_of(Conference).to receive(:save).and_return(false)
        post :create, { conference: { name: "" } }
        expect(assigns(:conference)).to be_a_new(Conference)
      end
    end

  end

end