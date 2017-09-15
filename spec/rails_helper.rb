require 'simplecov'
SimpleCov.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'email_spec'
require 'email_spec/rspec'
require 'cancan/matchers'
require 'poltergeist_warnings_suppressor'
require 'paper_trail/frameworks/rspec'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'

# For capybara-screenshot, so when running a development server, the screenshots look better
Capybara.asset_host = 'http://localhost:3001'
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "screenshot_#{example.description.gsub(/\W/, '-').gsub(/^.*\/spec\//, '')}"
end
Capybara::Screenshot.append_timestamp = false
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Screenshot::RSpec.add_link_to_screenshot_for_failed_examples = false

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.include FactoryGirl::Syntax::Methods

  config.include SelectDateAndTime, type: :feature

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end

# Set locale for view specs, see https://github.com/rspec/rspec-rails/issues/255#issuecomment-2865917
class ActionView::TestCase::TestController
  def default_url_options(options = {})
    {locale: I18n.default_locale}
  end
end

# Set locale for feature specs, see https://github.com/rspec/rspec-rails/issues/255#issuecomment-24698753
RSpec.configure do |config|
  config.before(:each, type: :feature) do
    default_url_options[:locale] = I18n.default_locale
  end
end

# Set screen width to large by default
RSpec.configure do |config|
  config.before(:each, js: :true) do
    screen_width(:lg)
  end
end

# Set date and time always to 15th of june 2015 at 14:33:52
RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers

  config.before(:each) do
    travel_to DateTime.parse('2015-06-15 14:33:52 +0200')
  end

  config.after(:each) do
    travel_back
  end
end

RSpec.configure do |config|
  config.include Base::Matchers, type: :feature
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

require 'strip_attributes/matchers'
RSpec.configure do |config|
  config.include StripAttributes::Matchers
end

# Reset locale to default after each spec (otherwise it may persist, see http://stackoverflow.com/questions/36040661/rails-random-failures-in-specs-because-of-wrong-default-locale)
RSpec.configure do |config|
  config.after(:each) { I18n.locale = :en }
end
