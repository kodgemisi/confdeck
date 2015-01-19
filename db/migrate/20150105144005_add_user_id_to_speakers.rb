class AddUserIdToSpeakers < ActiveRecord::Migration
  def up
    add_reference :speakers, :user, index: true

    Speaker.all.each do |speaker|
      puts speaker.email
      user = User.find_by(email: speaker.email)

      if user #create relation
        puts "found user"
        speaker.user = user
      else #create user and relation
        puts "create user"
        #TODO Might be needed to send email here.
        user = User.new(
            email: speaker.email,
            password: Devise::friendly_token[0..7]
        )
        puts user.save
        puts user.errors.full_messages
        speaker.user = user
        puts user.id
        puts "save user"

      end
      speaker.save
      puts "create speaker"
      puts "==============="
    end
    remove_column :speakers, :email
  end

  def down
    remove_column :speakers, :user_id
  end
end
