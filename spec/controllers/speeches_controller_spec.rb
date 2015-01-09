require 'rails_helper'

#TODO authorization tests for conf admins and conf users

RSpec.describe SpeechesController do
  # Create valid attributes for post
  def valid_attributes
    @speaker = Fabricate(:speaker)
    {
      speech_type_id: @conference.speech_types.first.id,
      topic_attributes: {
          subject: "ROR 101",
          abstract: "Ruby on Rails 101",
          detail: "Details of ROR",
          additional_info: "ROR 4.2",
          speaker_ids: [@speaker.id]
      }
    }
  end

  before :all do
    @user = Fabricate(:user)
    @conference = Fabricate(:conference)
    @conference.conference_admins << @user
  end

  before :each do
    sign_in @user
  end


  describe "POST create" do
    describe "with valid params" do
      it "creates a new speech" do
        expect do
          post :create, { speech: valid_attributes, conference_id: @conference.id }
        end.to change(Speech, :count).by(1)
      end

      it "creates activity item with a new speech" do
        post :create, { speech: valid_attributes, conference_id: @conference.id }
        activity = Activity.last
        expect(activity.subject).to eq(assigns(:speech))
        expect(activity.action).to eq("speech_new")
        expect(activity.user).to eq(@user)
        expect(activity.conference).to eq(@conference)
      end
    end
  end

  describe "GET accept" do
    describe "with valid params" do
      before :each do
        @speech = Fabricate(:speech, conference: @conference, speech_type: @conference.speech_types.first)
      end

      it "accepts speech" do
        get :accept, { id: @speech.id, conference_id: @conference.id }
        @speech.reload
        expect(@speech.state).to eq("accepted")
      end

      it "creates activity item for accept" do
        get :accept, { id: @speech.id, conference_id: @conference.id }
        activity = Activity.last
        expect(activity.subject).to eq(@speech)
        expect(activity.action).to eq("speech_accept")
        expect(activity.user).to eq(@user)
        expect(activity.conference).to eq(@conference)
      end
    end
  end

  describe "GET reject" do
    describe "with valid params" do
      before :each do
        @speech = Fabricate(:speech, conference: @conference, speech_type: @conference.speech_types.first)
      end

      it "rejects speech" do
        get :reject, { id: @speech.id, conference_id: @conference.id }
        @speech.reload
        expect(@speech.state).to eq("rejected")
      end

      it "creates activity item for reject" do
        get :reject, { id: @speech.id, conference_id: @conference.id }
        activity = Activity.last
        expect(activity.subject).to eq(@speech)
        expect(activity.action).to eq("speech_reject")
        expect(activity.user).to eq(@user)
        expect(activity.conference).to eq(@conference)
      end
    end
  end

  describe "GET upvote" do
    describe "with valid params" do
      before :each do
        @speech = Fabricate(:speech, conference: @conference, speech_type: @conference.speech_types.first)
      end

      it "creates upvote" do
        expect do
          get :upvote, { id: @speech.id, conference_id: @conference.id }
        end.to change(@speech.upvotes, :count).by(1)
      end

      it "creates activity item for upvote" do
        get :upvote, { id: @speech.id, conference_id: @conference.id }
        activity = Activity.last
        expect(activity.subject).to eq(@speech)
        expect(activity.action).to eq("speech_upvote")
        expect(activity.user).to eq(@user)
        expect(activity.conference).to eq(@conference)
      end
    end
  end

  describe "GET downvote" do
    describe "with valid params" do
      before :each do
        @speech = Fabricate(:speech, conference: @conference, speech_type: @conference.speech_types.first)
      end

      it "creates downvote" do
        expect do
          get :downvote, { id: @speech.id, conference_id: @conference.id }
        end.to change(@speech.downvotes, :count).by(1)
      end

      it "creates activity item for downvote" do
        get :downvote, { id: @speech.id, conference_id: @conference.id }
        activity = Activity.last
        expect(activity.subject).to eq(@speech)
        expect(activity.action).to eq("speech_downvote")
        expect(activity.user).to eq(@user)
        expect(activity.conference).to eq(@conference)
      end
    end
  end

  describe "POST comment" do
    describe "with valid params" do
      before :each do
        @speech = Fabricate(:speech, conference: @conference, speech_type: @conference.speech_types.first)
      end

      it "creates comment" do
        expect do
          post :comment, { id: @speech.id, conference_id: @conference.id, comment: { comment: "selam" } }
        end.to change(@speech.comments, :count).by(1)
      end

      it "creates activity item for comment" do
        post :comment, { id: @speech.id, conference_id: @conference.id, comment: { comment: "selam" } }
        activity = Activity.last
        expect(activity.subject).to eq(@speech)
        expect(activity.action).to eq("speech_comment")
        expect(activity.user).to eq(@user)
        expect(activity.conference).to eq(@conference)
      end
    end
  end

end