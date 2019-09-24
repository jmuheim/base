# Although transactions are faster than truncation, we use truncation for cleaning the database.
#
# The reason is that transactions don't reset the auto increment value of tables (see http://stackoverflow.com/questions/11996522). Although it's a bit smelly, we rely on hard coded IDs in specs quite heavily, as it's much easier in some cases.
RSpec.configure do |config|
  config.around(:each) do |example|
    # See https://github.com/DatabaseCleaner/database_cleaner/issues/445
    DatabaseCleaner.clean_with :truncation, except: %w(ar_internal_metadata schema_migrations)

    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
