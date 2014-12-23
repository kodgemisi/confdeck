require 'rails_helper'

describe "Conference creation wizard", :type => :feature do
  let(:conference) { Fabricate(:conference) }

  it "should have a valid fabricator" do
    visit(conference_path(id: conference.slug))

    expect(conference).to be_valid
  end

  it "should display conference email mailto link" do
    visit(conference_path(id: conference.slug))
    expect(page).to have_content("")
  end

end