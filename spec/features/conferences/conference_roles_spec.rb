require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Conference roles ", :type => :feature do
  before :all do
    I18n.locale = :en
  end

  before :each do
    Conference.destroy_all
    sleep 2
  end

  context "conference admin" do
    before :each do
      @user = Fabricate(:user)
      @user.set!("language", "en")
      login_as(@user, :scope => :user)
      @conference = Fabricate.build(:conference)
      @conference.conference_admins << @user
    end

    context "for speeches" do
      before :each do
        @speech_type = Fabricate(:speech_type, conference: @conference)
        @speech1 = Fabricate(:speech, conference: @conference, state: "accepted", speech_type: @speech_type)
        @speech2 = Fabricate(:speech, conference: @conference, state: "accepted", speech_type: @speech_type)
        @speech3 = Fabricate(:speech, conference: @conference, state: "waiting_review", speech_type: @speech_type)
        @speech4 = Fabricate(:speech, conference: @conference, state: "rejected", speech_type: @speech_type)
      end

      it "can accept one" do
        visit(admin_speech_url(@speech3, subdomain: @conference.slug))
        click_link(I18n.t("speeches.accept"))
        expect(page).to have_content("Accepted")
      end

      it "can reject one" do
        visit(admin_speech_url(@speech3, subdomain: @conference.slug))
        click_link(I18n.t("speeches.accept"))
        expect(page).to have_content("Accepted")
      end
    end
  end

  context "conference user" do
    before :each do
      @user = Fabricate(:user)
      @user.set!("language", "en")
      login_as(@user, :scope => :user)
      @conference = Fabricate(:conference)
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
        visit(admin_speeches_url(subdomain: @conference.slug))
        expect(page).to have_content(@speech1.topic.subject)
      end

      it "can see details of one" do
        visit(admin_speech_url(@speech1, subdomain: @conference.slug))
        expect(page).to have_content(@speech1.topic.subject)
      end

      it "can comment about one", js: true do
        visit(admin_speech_url(@speech1, subdomain: @conference.slug))
        comment = "zeki müren de bizi görecek mi?"
        fill_in 'comment_comment', :with => comment
        click_button "Create Comment"
        sleep(3)
        expect(page).to have_content(comment)
        expect(@speech1.comments.last.comment).to eq(comment)
      end

      it "can upvote to one on speech page", js: true do
        expect(@user.voted_up_on?(@speech1)).to be false
        visit(admin_speech_url(@speech1, subdomain: @conference.slug))
        find("#speech_#{@speech1.id}").find(".action-upvote").click
        sleep(3)
        expect(@user.voted_up_on?(@speech1)).to be true
      end

      it "can upvote to one on speech list page", js: true do
        expect(@user.voted_up_on?(@speech1)).to be false
        visit(admin_speech_url(@speech1, subdomain: @conference.slug))
        find("#speech_#{@speech1.id}").find(".action-upvote").click
        sleep(3)
        expect(@user.voted_up_on?(@speech1)).to be true
      end

      it "can downvote to one on speech page", js: true do
        expect(@user.voted_down_on?(@speech1)).to be false
        visit(admin_speech_url(@speech1, subdomain: @conference.slug))
        find("#speech_#{@speech1.id}").find(".action-downvote").click
        sleep(3)
        expect(@user.voted_down_on?(@speech1)).to be true
      end

      it "can downvote to one on speech list page", js: true do
        expect(@user.voted_down_on?(@speech1)).to be false
        visit(admin_speeches_url(subdomain: @conference.slug))
        find("#speech_#{@speech1.id}").find(".action-downvote").click
        sleep(3)
        expect(@user.voted_down_on?(@speech1)).to be true
      end

      it "can't accept one" do
        visit(accept_admin_speech_url(@speech1, subdomain: @conference.slug))
        expect(page).to have_content(I18n.t("general.not_authorized"))
      end

      it "can't reject one" do
        visit(reject_admin_speech_url(@speech1, subdomain: @conference.slug))
        expect(page).to have_content(I18n.t("general.not_authorized"))
      end
    end
  end
end