# config/initializers/localeapp.rb
require 'localeapp/rails'

Localeapp.configure do |config|
    config.api_key = '' # add key when you get it, Localeapp complains if this is unset!
    # you'll also want to add other config on setup, see README.md
    config.polling_environments = []

end
