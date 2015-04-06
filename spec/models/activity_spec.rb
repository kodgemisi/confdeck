require 'rails_helper'

RSpec.describe Activity, :type => :model do

  context 'notifications' do
    before :each do
      @conference = Fabricate(:conference)
      @admins = Fabricate.times(3, :user)
      @users = Fabricate.times(3, :user)
      @conference.conference_admins << @admins
      @conference.conference_users << @users

    end
    
    it 'creates notifications except activitys user' do
      @activity = Activity.create(
          user: @admins[0],
          conference: @conference,
          action: 'speech_comment',
          subject: Comment.create
      )
      puts User.count
      expect(Notification.count).to eq(@conference.users.count - 1)
      expect(@admins[1].notifications.count).to eq(1)
      expect(@users[1].notifications.count).to eq(1)
    end


  end


end
