require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Conference roles ", :type => :feature do

  context "conference user" do
    before :each do
      @user = Fabricate(:user)
      @user.set!("language", "en")
      login_as(@user, :scope => :user)
      @conference = Fabricate.build(:conference)
      @conference.conference_users << @user
    end

    context "for speeches" do
      before :each do
        @speech_type = Fabricate(:speech_type, conference: @conference)
        @speech1 = Fabricate(:speech, conference: @conference, state: "accepted", speech_type: @speech_type)
        @speech2 = Fabricate(:speech, conference: @conference, state: "accepted", speech_type: @speech_type)
        @speech3 = Fabricate(:speech, conference: @conference, state: "waiting_review", speech_type: @speech_type)
        @speech4 = Fabricate(:speech, conference: @conference, state: "rejected", speech_type: @speech_type)
      end


      it "can see list" do
        visit(conference_speeches_path(conference_id: @conference.slug))
        expect(page).to have_content(@speech1.topic.subject)
      end

      it "can see details of one" do
        visit(conference_speech_path(@conference, @speech1))
        expect(page).to have_content(@speech1.topic.subject)
      end

      it "can comment about one", js: true do
        visit(conference_speech_path(@conference, @speech1))
        comment = "zeki müren de bizi görecek mi?"
        fill_in 'comment_comment', :with => comment
        click_button "Create Comment"
        sleep(3)
        expect(page).to have_content(comment)
        expect(Comment.last.comment).to eq(comment)
      end
    end

  end

end