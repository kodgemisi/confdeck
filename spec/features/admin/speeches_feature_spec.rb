require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Admin Speeches", :type => :feature do
  before :all do
    @user = Fabricate(:user)
    @user.set!("language", "en")
    login_as(@user, :scope => :user)
    @conference = Fabricate(:conference)
    @conference.conference_admins << @user
  end
  let(:speech) { Fabricate.build(:speech) }
  let(:speaker) { Fabricate.build(:speaker) }


  context "conference admin can" do
    it 'go to new speech page' do
      visit(admin_conference_url(subdomain: @conference.slug))
      find('.sidebar').click_link("Speeches")
      click_link('New Speech')
      expect(page).to have_content('New Speech')
    end


    it 'create a new speech' do
      visit(new_admin_speech_url(subdomain: @conference.slug))

      page.click_link I18n.t("conferences.new_speaker")

      page.fill_in("speaker[name]", with: speaker.name)
      page.fill_in("speaker[email]", with: speaker.user.email)
      page.fill_in("speaker[phone]", with: speaker.phone)
      page.click_button 'Create Speaker'
      sleep 5

      page.fill_in("speech[topic_attributes][subject]", with: speech.topic.subject)
      page.fill_in("speech[topic_attributes][abstract]", with: speech.topic.abstract)
      page.fill_in("speech[topic_attributes][detail]", with: speech.topic.detail)
      page.fill_in("speech[topic_attributes][additional_info]", with: speech.topic.additional_info)

      page.click_button "Create Speech"

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

      expect(@last_speech.state).to eq('accepted')
    end
  end
end