# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rspec'
require 'capybara/rails'
require 'selenium-webdriver'
I18n.locale = :en

driver = :webkit
#driver = :selenium
Capybara.current_driver = driver
Capybara.javascript_driver = driver
#Selenium::WebDriver::Firefox::Binary.path = "/home/mehmet/Desktop/firefox/firefox" #To fix bug of Firefox 35 with selenium
Capybara.configure do |config|
  config.always_include_port = true
  # config.app_host = 'http://lvh.me'
  # config.default_host = 'http://lvh.me'
end

ActiveRecord::Migration.maintain_test_schema!
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.include Devise::TestHelpers, :type => :controller
  config.include Warden::Test::Helpers, :type => :feature

  config.infer_spec_type_from_file_location!

  config.before(:each, :type => :feature) do
    if Capybara.current_driver == :webkit
      page.driver.allow_url("csi.gstatic.com")
      page.driver.allow_url("mt0.googleapis.com")
      page.driver.allow_url("maps.googleapis.com")
      page.driver.allow_url("maps.gstatic.com")
      page.driver.allow_url("www.example.com")
      page.driver.allow_url("confdeck.atlassian.net")
      page.driver.allow_url("fonts.googleapis.com")
      page.driver.allow_url("mt1.googleapis.com")
      page.driver.allow_url("gravatar.com")
      page.driver.allow_url '*.example.com'
      page.driver.allow_url 'example.com/*.js'

    end
  end

  config.after(:each, :type => :feature) do
    Warden.test_reset!
  end
end


