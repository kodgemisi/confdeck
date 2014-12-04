# config/initializers/localeapp.rb
require 'localeapp/rails'

Localeapp.configure do |config|
    config.api_key = ENV["LOCALEAPP_KEY"]
    # you'll also want to add other config on setup, see README.md
    config.polling_environments = []
    config.sending_environments = []

end
