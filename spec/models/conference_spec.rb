require 'spec_helper'

describe Conference do

  it { should have_one(:address) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:summary) }
  it { should validate_presence_of(:from_date) }
  it { should validate_presence_of(:to_date) }

end