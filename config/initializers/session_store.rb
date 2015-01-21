# Be sure to restart your server when you modify this file.

if Rails.env == "production"
  Confman::Application.config.session_store :cookie_store, key: '_confman_session_prod', :domain => '.confdeck.com'
elsif Rails.env == "test"
  Confman::Application.config.session_store :cookie_store, key: '_confman_session_test', :domain => '.example.com'
else
  Confman::Application.config.session_store :cookie_store, key: '_confman_session_dev', :domain => '.confdeck.dev'
end


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Confman::Application.config.session_store :active_record_store
