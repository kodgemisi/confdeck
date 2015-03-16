RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each, type: :js) do

    puts "   ######## END FEATURE ############# #{Conference.count}"

  end

  config.after(:each) do
    puts 'DELETED'
    DatabaseCleaner.clean
  end
end