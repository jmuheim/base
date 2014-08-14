# DatabaseCleaner configuration as described here: http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = if example.metadata[:js] ||
                                  example.metadata[:chrome] ||
                                  example.metadata[:selenium]
                                 :truncation # Otherwise we get an SQLite3::BusyException because more than one thread try to modify the database, see http://stackoverflow.com/questions/12326096
                               else
                                 :transaction
                               end

    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
