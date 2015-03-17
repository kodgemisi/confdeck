require "#{Rails.root}/lib/email_processor.rb"
Griddler.configure do |config|
  config.email_service = :sendgrid # :cloudmailin, :postmark, :mandrill, :mailgun
  config.reply_delimiter = '____'

end