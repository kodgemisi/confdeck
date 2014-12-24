require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Conference creation wizard", :type => :feature do

  before :each do
    @user = Fabricate(:user)
    @user.set!("language", "en")
    login_as(@user, :scope => :user)
    @conference = Fabricate.build(:conference)
    @organization = @conference.organizations.first
    @user.organizations << @organization
  end


  # it "should validate required fields are working properly" do
  #   visit(new_conference_path)
  #   sleep 10
  #   page.execute_script("$('#from').datepicker('setDate', '#{@conference.from_date}')")
  #   page.execute_script("$('#to').datepicker('setDate', '#{@conference.to_date}')")
  #   page.select(@organization.name, from: 'conference[organization_ids][]')
  #   page.fill_in("conference[name]", with: @conference.name)
  #   page.fill_in("conference[description]", with: @conference.description)
  #   #We are testing only summary field here but assuming all fields with 'required' class have same behaviour
  #   page.fill_in("conference[summary]", with: "")
  #   page.click_link ("Next")
  #   expect(page).to have_content("This field is required")
  #   page.fill_in("conference[summary]", with: @conference.summary)
  #   page.click_link ("Next")
  #   expect(page).to have_content("info")
  # end
  #
  # # We assume every field that has 'required' class is required and they are being validated by jquery.validator in previous spec
  # it "should validate presence of name" do
  #   visit(new_conference_path)
  #   expect(page.find("input[name='conference[name]']")[:class]).to include("required")
  # end
  #
  # it "should validate presence of summary" do
  #   visit(new_conference_path)
  #   expect(page.find("input[name='conference[summary]']")[:class]).to include("required")
  # end
  #
  # it "should validate presence of from date" do
  #   visit(new_conference_path)
  #   expect(page.find("#from")[:class]).to include("required")
  # end
  #
  # it "should validate presence of to date" do
  #   visit(new_conference_path)
  #   expect(page.find("#to")[:class]).to include("required")
  # end


  #== Step 1
  context "with valid data in step 1", js: true do
    #Fill fields in step 1
    before do
      visit(new_conference_path)
      page.execute_script("$('#from').datepicker('setDate', '#{@conference.from_date}')")
      page.execute_script("$('#to').datepicker('setDate', '#{@conference.to_date}')")
      page.select(@organization.name, from: 'conference[organization_ids][]')
      page.fill_in("conference[name]", with: @conference.name)
      page.fill_in("conference[summary]", with: @conference.summary)
      page.fill_in("conference[description]", with: @conference.description)
      page.click_link ("Next")
    end

    #== Step 2
    context "it should pass to next step" do
      #Make sure it passes to step 2
      it do
        expect(page).to have_content("info")
      end

      context "with valid data in step 2" do
        #Fill fields in step 2
        before do
          page.fill_in("conference[address_attributes][info]", with: @conference.address.info)
          page.fill_in("conference[address_attributes][city]", with: @conference.address.city)
          page.click_link ("Next")
          sleep 1
        end


        #== Step 3
        context "it should pass to next step" do
          #Make sure it passes to step 3
          it do
            #expect(page).to have_content("Speech")
          end

          context "with valid data in step 3" do
            #Fill fields
            before do
              @speech_type = Fabricate(:speech_type)
              page.find(".speech-types").find("input[type=text]").set(@speech_type.type_name)
              page.click_link ("Next")
            end

            context "it should pass to next step" do
              #Make sure it passes to step 4
              it do
                #expect(page).to have_content("Website")
              end

              it "with valid data in step 4" do

                page.fill_in("conference[email]", with: @conference.email)
                page.fill_in("conference[phone]", with: @conference.phone)
                page.click_link ("Finish")
                sleep 2

                last_conf = Conference.last
                expect(@conference.name).to eq(last_conf.name)
                expect(@conference.email).to eq(last_conf.email)

              end
            end

          end

        end
      end
    end
  end

end