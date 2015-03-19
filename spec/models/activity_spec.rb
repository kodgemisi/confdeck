require 'rails_helper'

RSpec.describe Activity, :type => :model do

  it 'creates notifications' do
    @conference = Fabricate(:conference)
    @admins = Fabricate.times(3, :user)
    @users = Fabricate.times(3, :user)
    @conference.conference_admins << @admins
    @conference.conference_users << @users

    activity = Activity.create(
        user: @admins[1],
        conference: @conference,
        action: 'speech_comment',
        subject: Comment.create
    )

    expect(Notification.count).to eq(@conference.users.count)
    expect(@admins[1].notifications.count).to eq(1)
    expect(@users[1].notifications.count).to eq(1)
  end


end
