class EmailProcessor
  def initialize(email)
    @email = email
    @to = @email.headers['To']
    @speech_id = @to.split('@')[0].try(:split, '-')[1]
    @sender = @email.from[:email]
    @body = EmailReplyParser.parse_reply(@email.raw_body).gsub('\n', '<br />')
  end

  def process
    if @speech_id
      @speech = Speech.find(@speech_id)
      @user = User.find_by(email: @sender)
      if @speech
        if @user
          comment = @speech.comments.create(
              comment: @body,
              user: @user,
              sent_by_email: true
          )
        else
          @user = User.anonym
          @body = "#{@body} <br /><br /> #{@email.from[:email]}"
          comment = @speech.comments.create(
              comment: @body,
              user: @user,
              sent_by_email: true
          )
        end
      end
    end
  end
end