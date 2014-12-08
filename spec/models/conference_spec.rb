require 'rails_helper'

describe Conference do

  it "should have a start date which is before or equal to its end date" do
      Fabricate(:conference)
    should validate_presence_of(:name)
  end


  it "should have a start time and end time if it is a one day conference"
  it "should have a slot if it is a one day conference"
  it "should have a start time which is before its end time"
  it "should have at least one AppealType"

  # it { should have_one(:address) }
  # it { should validate_presence_of(:name) }
  # it { should validate_presence_of(:email) }
  # it { should validate_presence_of(:from_date) }
  # it { should validate_presence_of(:to_date) }

end