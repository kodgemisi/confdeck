class EmailProcessor
  def initialize(email)
    @email = email
    @to = @email.headers['To']
    @speech_id = @to.split('@')[0].try(:split, '-')[1]
    @sender = @email.from[:email]
    @body = EmailReplyParser.parse_reply(@email.body)
    puts @body
  end

  def process

    if @speech_id
      @speech = Speech.find(@speech_id)
      @user = User.find_by(email: @sender)
      puts @user.id
      puts "-----"
      puts @speech.id
      if @speech && @user
        comment = @speech.comments.create(
            comment: @body,
            user: @user
        )
      else
        #TODO if user not found. add email to comment content
      end
    end
  end
end