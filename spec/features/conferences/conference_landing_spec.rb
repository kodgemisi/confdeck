require 'rails_helper'

describe "Conference landing page", :type => :feature do

  context "modules" do

    context "organizations" do
      let(:organization) { Fabricate(:organization) }
      let(:conference) { Fabricate(:conference, organizations: [organization]) }

      it "should display organizations if module is active" do
        visit(conference_path(id: conference.slug))
        expect(page).to have_content organization.name
      end

      it "should not display organizations if module is not active" do
        conference.set!("organizators_module", "false")
        conference.save
        visit(conference_path(id: conference.slug))
        expect(page).not_to have_content organization.name
      end

      it "should display organizations link if module is active" do
        visit(conference_path(id: conference.slug))
        expect(page).to have_link('Organizations', :href => '#organizations')

      end

      it "should not display organizations link if module is not active" do
        conference.set!("organizators_module", "false")
        conference.save
        visit(conference_path(id: conference.slug))
        expect(page).not_to have_link('Organizations', :href => '#organizations')
      end
    end

    context "application" do
      let(:conference) { Fabricate(:conference) }

      it "should display application button if module is active" do
        visit(conference_path(id: conference.slug))
        expect(page).to have_content I18n.t("conferences.landing.speaker_application")
      end

      it "should not display application button if module is not active" do
        conference.set!("application_module", "false")
        conference.save
        visit(conference_path(id: conference.slug))
        expect(page).not_to have_content I18n.t("conferences.landing.speaker_application")
      end
    end

    context "speakers" do
      let!(:conference) { Fabricate(:conference) }

      before :each do
        @appeal1 = Fabricate(:appeal, conference: conference, state: "accepted")
        @appeal2 = Fabricate(:appeal, conference: conference, state: "accepted")
        @appeal3 = Fabricate(:appeal, conference: conference, state: "waiting_review")
        @appeal4 = Fabricate(:appeal, conference: conference, state: "rejected")
      end

      it "should display list of speakers" do
        visit(conference_path(id: conference.slug))
        @appeal1.topic.speakers.each do |speaker|
          expect(page).to have_content speaker.name
        end

        @appeal2.topic.speakers.each do |speaker|
          expect(page).to have_content speaker.name
        end
      end

      it "should display list of speakers of only accepted topic" do
        visit(conference_path(id: conference.slug))

        @appeal1.topic.speakers.each do |speaker|
          expect(page).to have_content speaker.name
        end

        @appeal2.topic.speakers.each do |speaker|
          expect(page).to have_content speaker.name
        end

        @appeal3.topic.speakers.each do |speaker|
          expect(page).not_to have_content speaker.name
        end

        @appeal3.topic.speakers.each do |speaker|
          expect(page).not_to have_content speaker.name
        end
      end
    end
  end

end
