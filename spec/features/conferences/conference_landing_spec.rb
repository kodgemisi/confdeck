require 'rails_helper'

describe "Conference landing page", :type => :feature do
  let(:conference) { Fabricate(:conference) }

  it "should display conference details" do
    visit(conference_url(subdomain: conference.slug))
    expect(page).to have_content conference.name
    expect(page).to have_content conference.summary
    expect(page).to have_content conference.description
    expect(page).to have_content conference.keywords
    expect(page).to have_content conference.address.city
  end


  it "should display conference email mailto link" do
    visit(conference_url(subdomain: conference.slug))
    expect(page).to have_link("",href:"mailto:#{conference.email}")
  end


  context "modules" do

    context "organizations" do
      let(:organization) { Fabricate(:organization) }
      let(:conference) { Fabricate(:conference, organizations: [organization]) }

      it "should display organizations if module is active" do
        visit(conference_url(subdomain: conference.slug))
        expect(page).to have_content organization.name
      end

      it "should not display organizations if module is not active" do
        conference.set!("organizators_module", "false")
        conference.save
        visit(conference_url(subdomain: conference.slug))
        expect(page).not_to have_content organization.name
      end

      it "should display organizations link if module is active" do
        visit(conference_url(subdomain: conference.slug))
        expect(page).to have_link('Organizations', :href => '#organizations')

      end

      it "should not display organizations link if module is not active" do
        conference.set!("organizators_module", "false")
        conference.save
        visit(conference_url(subdomain: conference.slug))
        expect(page).not_to have_link('Organizations', :href => '#organizations')
      end
    end

    context "application" do
      let(:conference) { Fabricate(:conference) }

      it "should display application button if module is active" do
        visit(conference_url(subdomain: conference.slug))
        expect(page).to have_content I18n.t("conferences.landing.speaker_application")
      end

      it "should not display application button if module is not active" do
        conference.set!("application_module", "false")
        conference.save
        visit(conference_url(subdomain: conference.slug))
        expect(page).not_to have_content I18n.t("conferences.landing.speaker_application")
      end
    end

    context "speakers" do
      let!(:conference) { Fabricate(:conference) }

      before :each do
        @speech1 = Fabricate(:speech, conference: conference, state: "accepted")
        @speech2 = Fabricate(:speech, conference: conference, state: "accepted")
        @speech3 = Fabricate(:speech, conference: conference, state: "waiting_review")
        @speech4 = Fabricate(:speech, conference: conference, state: "rejected")
      end

      it "should display list of speakers if module is active" do
        visit(conference_url(subdomain: conference.slug))
        @speech1.topic.speakers.each do |speaker|
          expect(page).to have_content speaker.name
        end

        @speech2.topic.speakers.each do |speaker|
          expect(page).to have_content speaker.name
        end
      end

      it "should not display list of speakers if module is not active" do
        conference.set!("speakers_module", "false")
        conference.save
        visit(conference_url(subdomain: conference.slug))
        @speech1.topic.speakers.each do |speaker|
          expect(page).not_to have_content speaker.name
        end
      end

      it "should display list of speakers of only accepted topic" do
        visit(conference_url(subdomain: conference.slug))

        @speech1.topic.speakers.each do |speaker|
          expect(page).to have_content speaker.name
        end

        @speech2.topic.speakers.each do |speaker|
          expect(page).to have_content speaker.name
        end

        @speech3.topic.speakers.each do |speaker|
          expect(page).not_to have_content speaker.name
        end

        @speech3.topic.speakers.each do |speaker|
          expect(page).not_to have_content speaker.name
        end
      end
    end


    context "map" do
      it "should display address if module is active" do
        visit(conference_url(subdomain: conference.slug))
        expect(page).to have_content conference.address.info
      end

      it "should not display address if module is not active" do
        conference.set!("map_module", "false")
        conference.save
        visit(conference_url(subdomain: conference.slug))
        expect(page).not_to have_content conference.address.info
      end
    end
  end

end
