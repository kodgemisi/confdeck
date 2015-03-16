require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Conference creation wizard", :type => :feature do

  before :each do
    Fabricate.create(:email_template_type, type_name: 'accept_notification_email')
    Fabricate.create(:email_template_type, type_name: 'reject_notification_email')
    Fabricate.create(:email_template_type, type_name: 'speaker_notification_email')
    Fabricate.create(:email_template_type, type_name: 'committee_notification_email')

    @user = Fabricate(:user)
    @user.set!("language", "en")
    @conference = Fabricate.build(:conference)
    @organization = @conference.organizations.first
    @user.organizations << @organization
    @user.conference_wizard.destroy! if @user.conference_wizard
    login_as(@user, :scope => :user)
  end

  it "should validate required fields are working properly", js: true do
    visit(new_conferences_url)
    page.execute_script("$('#from').datepicker('setDate', '#{@conference.from_date}')")
    page.execute_script("$('#to').datepicker('setDate', '#{@conference.to_date}')")
    page.select(@organization.name, from: 'conference[organization_ids][]')
    page.fill_in("conference[name]", with: @conference.name)
    sleep 2
    page.fill_in("conference[description]", with: @conference.description)
    sleep 2
    page.fill_in("conference[email]", with: @conference.email)
    sleep 2
    #We are testing only summary field here but assuming all fields with 'required' class have same behaviour
    page.fill_in("conference[summary]", with: "")
    sleep 2
    page.click_link ("Next")
    expect(page).to have_content("This field is required")
    page.fill_in("conference[summary]", with: @conference.summary)
    sleep 2
    page.click_link ("Next")
    expect(page).to have_content("Speech Types")
  end

  # We assume every field that has 'required' class is required and they are being validated by jquery.validator in previous spec
  it "should validate presence of name" do
    visit(new_conferences_path)
    expect(page.find("input[name='conference[name]']")[:class]).to include("required")
  end

  it "should validate presence of summary" do
    visit(new_conferences_path)
    expect(page.find("input[name='conference[summary]']")[:class]).to include("required")
  end

  it "should validate presence of from date" do
    visit(new_conferences_path)
    expect(page.find("#from")[:class]).to include("required")
  end

  it "should validate presence of to date" do
    visit(new_conferences_path)
    expect(page.find("#to")[:class]).to include("required")
  end

  context "with valid data for multiday conference", js: true do
    it "can complete the wizard" do

      # Step 1
      visit(new_conferences_url)
      page.execute_script("$('#from').datepicker('setDate', '#{@conference.from_date}')")
      page.execute_script("$('#to').datepicker('setDate', '#{@conference.to_date}')")
      page.select(@organization.name, from: 'conference[organization_ids][]')
      page.fill_in("conference[name]", with: @conference.name)
      page.fill_in("conference[summary]", with: @conference.summary)
      page.fill_in("conference[description]", with: @conference.description)
      page.fill_in("conference[email]", with: @conference.email)
      page.click_link ("Next")
      sleep 2

      #Step 2
      expect(page).to have_content("Speech")
      @speech_type = Fabricate(:speech_type)
      page.first(".add_fields")
      page.find(".speech-types").all("input[type=text]")[0].set(@speech_type.type_name_en)
      page.find(".speech-types").all("input[type=text]")[1].set(@speech_type.type_name_tr)
      #page.fill_in("conference[sponsors_attributes][0][name]", with: "MuhabbetKuşuSevenlerDernegi")
      #page.fill_in("conference[sponsors_attributes][0][website]", with: "http://muhabbet.com")
      page.click_link ("Next")
      sleep 2

      #Step 3
      expect(page).to have_content("City")
      page.fill_in("conference[address_attributes][info]", with: @conference.address.info)
      page.fill_in("conference[address_attributes][city]", with: @conference.address.city)
      page.click_link("Next")
      sleep 2

      #Step 4
      expect(page).to have_content(EmailTemplateType.find_by(type_name: 'speaker_notification_email').title)
      page.click_link("Next")
      sleep 2

      #Step 4
      expect(page).to have_content("Website")
      page.fill_in("conference[phone]", with: @conference.phone)
      page.click_link ("Finish")
      sleep 2

      last_conf = Conference.last
      expect(@conference.name).to eq(last_conf.name)
      expect(@conference.email).to eq(last_conf.email)

      page.click_link ("Open Conference Page")
      expect(page).to have_content(@conference.name)
    end
  end

  context "with valid data for one day conference", js: true do
    before :each do
      @conference = Fabricate.build(:one_day_conference)
      @organization = @conference.organizations.first
      @user.organizations << @organization
      @user.conference_wizard.destroy! if @user.conference_wizard
    end

    it "can complete the wizard" do

      # Step 1
      visit(new_conferences_url)
      page.execute_script("$('#from').datepicker('setDate', '#{@conference.from_date}')")
      page.execute_script("$('#to').datepicker('setDate', '#{@conference.to_date}')")
      page.select(@organization.name, from: 'conference[organization_ids][]')
      page.fill_in("conference[name]", with: @conference.name)
      page.fill_in("conference[summary]", with: @conference.summary)
      page.fill_in("conference[description]", with: @conference.description)
      page.fill_in("conference[email]", with: @conference.email)
      page.click_link ("Next")
      sleep 1

      #Step 2
      expect(page).to have_content("Speech")
      @speech_type = Fabricate(:speech_type)
      page.first(".add_fields")
      page.find(".speech-types").all("input[type=text]")[0].set(@speech_type.type_name_en)
      page.find(".speech-types").all("input[type=text]")[1].set(@speech_type.type_name_tr)
      #page.fill_in("conference[sponsors_attributes][0][name]", with: "MuhabbetKuşuSevenlerDernegi")
      #page.fill_in("conference[sponsors_attributes][0][website]", with: "http://muhabbet.com")
      page.click_link ("Next")
      sleep 1

      #Step 3
      expect(page).to have_content("City")
      page.fill_in("conference[address_attributes][info]", with: @conference.address.info)
      page.fill_in("conference[address_attributes][city]", with: @conference.address.city)
      page.click_link("Next")
      sleep 1

      #Step 4
      expect(page).to have_content(EmailTemplateType.find_by(type_name: 'speaker_notification_email').title)
      page.click_link("Next")
      sleep 1

      #Step 4
      expect(page).to have_content("Website")
      page.fill_in("conference[phone]", with: @conference.phone)
      page.click_link ("Finish")
      sleep 1

      last_conf = Conference.last
      expect(@conference.name).to eq(last_conf.name)
      expect(@conference.email).to eq(last_conf.email)

      page.click_link ("Open Conference Page")
      sleep 2

      expect(page).to have_content(@conference.name)
    end
  end

end