source 'http://rubygems.org' # FIXME: Use https!

gem 'rails', '4.0.2'

gem 'sqlite3' # Use sqlite3 as the database for Active Record

gem 'slim-rails' # Awesome template language that replaces ERB

gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets

gem 'coffee-rails', '~> 4.0.0' # Use CoffeeScript for .js.coffee assets and views

gem 'sass-rails', '~> 4.0.0' # Use Sass for stylesheets

gem 'compass-rails' # Compass framework

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails' # Use jquery as the JavaScript library

gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks

gem 'jbuilder', '~> 1.2' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# Flexible authentication solution
gem 'devise'
# gem 'devise-i18n' # Translations

gem 'cancan' # Authorization library which restricts what resources a given user is allowed to access

gem 'rolify' # Manage roles of users

# Inherit RESTful actions in controllers
gem 'inherited_resources'
gem 'has_scope' # Maps controller filters to resource scopes
gem 'responders' # A set of Rails responders

gem 'cells' # View components

group :doc do
  gem 'sdoc', require: false # bundle exec rake doc:rails generates the API under doc/api.
end

group :development, :test do
  gem 'rspec-rails' # Testing tool for the Ruby programming language

  gem 'factory_girl_rails' # Test data generator

  gem 'jazz_hands' # Use Pry and its extensions instead of IRB

  gem 'ffaker' # Generates realistic fake data
end

group :development do
  gem 'quiet_assets' # Turns off assets pipeline log

  # Better Errors: Replaces the standard Rails error page with a more useful one
  gem 'better_errors'
  gem 'binding_of_caller' # Needed by better_errors to enable html console

  gem 'xray-rails' # Reveals your UI's bones with Cmd-X/Ctrl-X

  # Rails application preloader
  gem 'spring', github: 'guard/spring', branch: 'listen2'
  gem 'spring-commands-rspec' # Commands for RSpec
  gem 'listen'

  # Guard: automatically run commands when files are changed
  gem 'guard-rspec', require: false      # Automatically run tests
  gem 'terminal-notifier-guard'          # Mac OS X User Notifications for Guard
  gem 'guard-livereload', require: false # Automatically reload your browser when 'view' files are modified
  gem 'guard-pow', require: false        # Automatically manage Pow applications restart
  gem 'guard-bundler'                    # Automatically install/update gem bundle when needed
  gem 'guard-annotate'                   # Automatically run the annotate gem when needed

  gem 'powder', require: false # Configure POW server easily

  gem 'rack-livereload' # Enable LiveReload in Rails

  gem 'rb-fsevent', require: false # FSEvents API with signals handled

  gem 'rubocop', require: false # A robust Ruby code analyzer, based on the community Ruby style guide

  gem 'rip_hashrocket', # Replace hashrockets (=>) automatically
       git: 'git://github.com/jmuheim/rip_hashrocket',
       require: false
end

group :test do
  gem 'respec', require: false # Allows to rerun failed specs (first do `respec` to run all, then `respec f` or `respec 123` to run failed)

  gem 'fuubar' # The instafailing RSpec progress bar formatter

  gem 'email_spec' # Collection of RSpec matchers for testing email

  gem 'shoulda-matchers' # Collection of RSpec matchers

  gem 'database_cleaner' # Resets test database after each test

  # Capybara - Headless, JavaScript-executing browser for Selenium
  gem 'poltergeist'        # PhantomJS driver for Capybara
  gem 'launchy'            # Use `save_and_open_page` in request tests to automatically open a browser
  gem 'selenium-webdriver' # Selenium webdriver (needed to use Chrome driver)

  gem 'turnip', # Gherkin extension for RSpec to write acceptance tests
    git: 'git@github.com:eagletmt/turnip.git', branch: 'fix-line-number'

  gem 'guard-migrate' # Automatically run migrations when they are edited

  gem 'capybara-screenshot' # Automatically save screen shots when a scenario fails

  gem 'rspec-cells' # Test cells using RSpec

  # Find unused CSS selectors by scraping the generated HTML in acceptance tests
  gem 'deadweight',
    require: 'deadweight/rails',
    # git: 'git://github.com/jmuheim/deadweight'
    path: '../deadweight'
  gem 'colored' # Provides colored output

  gem 'headhunter', require: 'headhunter/rails', path: '../headhunter'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]