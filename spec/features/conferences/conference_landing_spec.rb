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
  end

end
