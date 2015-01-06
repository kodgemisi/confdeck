class AddUserIdToSpeakers < ActiveRecord::Migration
  def up
    add_reference :speakers, :user, index: true

    Speaker.all.each do |speaker|
      user = User.find_by(email: speaker.email)

      if user #create relation
        speaker.user = user
      else #create user and relation
        #TODO Might be needed to send email here.
        user = User.new(
            email: speaker.email,
            password: Devise::friendly_token[0..7]
        )
        user.save
        speaker.user = user
      end
      speaker.save
    end
    remove_column :speakers, :email
  end

  def down
    remove_column :speakers, :user_id
  end
end
