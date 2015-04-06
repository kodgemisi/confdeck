require 'rails_helper'

describe "Conference landing page", :type => :feature do
  before :each do
    @organization = Fabricate.create(:organization)
    @conference = Fabricate.create(:conference, organizations: [@organization])
    Fabricate.create(:email_template_type, type_name: 'accept_notification_email')
    Fabricate.create(:email_template_type, type_name: 'reject_notification_email')
    Fabricate.create(:email_template_type, type_name: 'speaker_notification_email')
    Fabricate.create(:email_template_type, type_name: 'committee_notification_email')

  end

  it "should display conference detailsx" do

  end

  it "should display conference details" do
    visit(conference_url(subdomain: @conference.slug))
    expect(page).to have_content @conference.name
    expect(page).to have_content @conference.summary
    expect(page).to have_content @conference.description
    expect(page).to have_content @conference.keywords
    expect(page).to have_content @conference.address.city
  end


  it "should display conference email mailto link" do
    visit(conference_url(subdomain: @conference.slug))
    expect(page).to have_link("",href:"mailto:#{@conference.email}")
  end


  context "modules" do

    context "organizations" do

      it "should display organizations if module is active" do
        visit(conference_url(subdomain: @conference.slug))
        expect(page).to have_content @organization.name
      end

      it "should not display organizations if module is not active" do
        @conference.set!("organizators_module", "false")
        @conference.save
        visit(conference_url(subdomain: @conference.slug))
        expect(page).not_to have_content @organization.name
      end

      it "should display organizations link if module is active" do
        visit(conference_url(subdomain: @conference.slug))
        expect(page).to have_link('Organizations', :href => '#organizations')

      end

      it "should not display organizations link if module is not active" do
        @conference.set!("organizators_module", "false")
        @conference.save
        visit(conference_url(subdomain: @conference.slug))
        expect(page).not_to have_link('Organizations', :href => '#organizations')
      end
    end

    context "application" do

      it "should display application button if module is active" do
        visit(conference_url(subdomain: @conference.slug))
        expect(page).to have_content I18n.t("conferences.landing.speaker_application")
      end

      it "should redirects to /apply when clicked apply button" do
        visit(conference_url(subdomain: @conference.slug))
        click_link(I18n.t("conferences.landing.speaker_application"))
        expect(page).to have_content(I18n.t("conferences.landing.new_application"))
      end

      it "should not display application button if module is not active" do
        @conference.set!("application_module", "false")
        @conference.save
        visit(conference_url(subdomain: @conference.slug))
        expect(page).not_to have_content I18n.t("conferences.landing.speaker_application")
      end
    end

    context "speakers" do

      before :each do
        @speech1 = Fabricate(:speech, conference: @conference, state: "accepted")
        @speech2 = Fabricate(:speech, conference: @conference, state: "accepted")
        @speech3 = Fabricate(:speech, conference: @conference, state: "waiting_review")
        @speech4 = Fabricate(:speech, conference: @conference, state: "rejected")
      end

      it "should display list of speakers if module is active" do
        visit(conference_url(subdomain: @conference.slug))
        @speech1.topic.speakers.each do |speaker|
          expect(page).to have_content speaker.name
        end

        @speech2.topic.speakers.each do |speaker|
          expect(page).to have_content speaker.name
        end
      end

      it "should not display list of speakers if module is not active" do
        @conference.set!("speakers_module", "false")
        @conference.save
        visit(conference_url(subdomain: @conference.slug))
        @speech1.topic.speakers.each do |speaker|
          expect(page).not_to have_content speaker.name
        end
      end

      it "should display list of speakers of only accepted topic" do
        visit(conference_url(subdomain: @conference.slug))

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
        visit(conference_url(subdomain: @conference.slug))
        expect(page).to have_content @conference.address.info
      end

      it "should not display address if module is not active" do
        @conference.set!("map_module", "false")
        @conference.save
        visit(conference_url(subdomain: @conference.slug))
        expect(page).not_to have_content @conference.address.info
      end
    end

    context "/apply" do
      let(:speech) { Fabricate.build(:speech) }
      let(:speaker) { Fabricate.build(:speaker) }

      it 'x' do

      end

      it "users can send a speech application", js: true do
        visit(apply_conference_url(subdomain: @conference.slug))
        page.click_link I18n.t("conferences.new_speaker")

        page.fill_in("speaker[name]", with: speaker.name)
        page.fill_in("speaker[email]", with: speaker.user.email)
        page.fill_in("speaker[phone]", with: speaker.phone)
        page.click_button 'Create Speaker'
        sleep 2

        page.fill_in("speech[topic_attributes][subject]", with: speech.topic.subject)
        page.fill_in("speech[topic_attributes][abstract]", with: speech.topic.abstract)
        page.fill_in("speech[topic_attributes][detail]", with: speech.topic.detail)
        page.fill_in("speech[topic_attributes][additional_info]", with: speech.topic.additional_info)

        page.click_button "Send Application"

        expect(page).to have_content(speech.topic.subject) #TODO update to test application received text
        @last_speech = Speech.last
        expect(@last_speech.topic.speakers.first.name).to eq(speaker.name)
        expect(@last_speech.topic.speakers.first.user.email).to eq(speaker.user.email)
        expect(@last_speech.topic.speakers.first.phone).to eq(speaker.phone)

        expect(@last_speech.topic.subject).to eq(speech.topic.subject)
        expect(@last_speech.topic.abstract).to eq(speech.topic.abstract)
        expect(@last_speech.topic.detail).to eq(speech.topic.detail)
        expect(@last_speech.topic.additional_info).to eq(speech.topic.additional_info)
        expect(@last_speech.topic.subject).to eq(speech.topic.subject)

      end
    end

  end

end
