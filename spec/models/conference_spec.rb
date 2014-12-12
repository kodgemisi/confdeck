require 'rails_helper'
include ConferencesHelper

describe Conference do

  it "shouldn't have a from date after to end date" do
    from_date = date_to_s(Date.today + 10.days)
    to_date = date_to_s(Date.today - 5.days)
    c = Fabricate.build(:conference, from_date: from_date, to_date: to_date)
    expect(c).to_not be_valid
  end

  it "should have a from date before or equal to end date" do
    from_date = date_to_s(Date.today + 10.days)
    to_date = date_to_s(Date.today + 15.days)
    c = Fabricate.build(:conference, from_date: from_date, to_date: to_date)
    expect(c).to be_valid
  end

  it "from date should be after today" do
    c = Fabricate.build(:conference)
    c.from_date = date_to_s(Date.today + 3.days)
    c.to_date =  date_to_s(Date.today + 4.days)
    expect(c).to be_valid
  end

  it "from date shouldnt be before today" do
    c = Fabricate.build(:conference)
    c.from_date = date_to_s(Date.today - 3.days)
    c.to_date =  date_to_s(Date.today + 3.days)
    expect(c).not_to be_valid
  end

  context "one day conference" do
    let(:conference) { Fabricate.build(:one_day_conference) }

    it "should have a start time" do
      expect(conference.start_time).not_to be_empty
    end

    it "should have an end time" do
      expect(conference.end_time).not_to be_empty
    end

    it "should have a start time before end time" do
      conference.start_time = Time.parse("11:00")
      conference.end_time = Time.parse("13:00")

      expect(conference).to be_valid
    end

    it "shouldnt have a start time after end time" do
      pending
      conference.start_time = Time.parse("15:00")
      conference.end_time = Time.parse("13:00")

      expect(conference).not_to be_valid
    end
  end

  it "should have a slot if it is a one day conference"

  # it { should have_one(:address) }
  it { should validate_presence_of(:from_date) }
  it { should validate_presence_of(:to_date) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:summary) }
  it { should validate_presence_of(:email) }

  it 'requires the presence of the slug' do
    conference = Fabricate.build(:conference, name: nil, slug: nil)
    expect(conference).not_to be_valid
    expect(conference.errors[:slug]).to be_present
  end

  it 'requires the uniqueness of the slug' do
    pending
    conference = Fabricate.create(:conference)
    another_conference = Fabricate.build(:conference, slug: conference.slug)
    another_conference.should_not be_valid
    another_conference.errors[:slug].should == ["is already taken"]
  end
end
