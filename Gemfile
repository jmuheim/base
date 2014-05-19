source 'https://rubygems.org'
source 'https://rails-assets.org'

gem 'rails', '4.1'

gem 'rails-i18n' # Locale data

gem 'slim-rails' # Awesome template language that replaces ERB

gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets

gem 'coffee-rails', '~> 4.0.0' # Use CoffeeScript for .js.coffee assets and views

gem 'sass-rails', '~> 4.0.0' # Use Sass for stylesheets

gem 'compass-rails' # Compass framework

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks: makes following links in your web application faster
gem 'turbolinks'
gem 'jquery-turbolinks' # jQuery plugin for drop-in fix binded events problem caused by Turbolinks

gem 'rails-assets-bootstrap-sass' # Sleek, intuitive, and powerful front-end framework
# gem 'rails-assets-bootstrap-formhelpers' # Assets are manually added at this moment, until this is fixed: https://github.com/rails-assets/rails-assets/issues/148
gem 'rails-assets-jquery-ui' # jQuery UI components
gem 'rails-assets-jquery-ujs-standalone' # Unobtrusive JS for Rails (standalone is optimised for rails-assets)

gem 'jbuilder', '~> 1.2' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# Flexible authentication solution
gem 'devise'
gem 'devise-i18n' # Translations

gem 'cancancan' # Authorization library which restricts what resources a given user is allowed to access

gem 'rolify' # Manage roles of users

# Inherit RESTful actions in controllers
gem 'inherited_resources', '>= 1.4.1'
gem 'has_scope' # Maps controller filters to resource scopes
gem 'responders' # A set of Rails responders

gem 'cells' # View components

gem 'simple_form', github: 'plataformatec/simple_form' # Forms made easy for Rails

gem 'gaffe' # Handles Rails error pages in a clean, simple way

gem 'cocoon' # Dynamic nested forms made easy

gem 'validates_timeliness' # Date and time validation plugin for ActiveModel and Rails

gem 'navigasmic' # Semantic navigation

group :doc do
  gem 'sdoc', require: false # bundle exec rake doc:rails generates the API under doc/api.
end

group :development, :test do
  gem 'sqlite3' # Use SQLite as the database for Active Record

  # Testing tool for the Ruby programming language
  gem 'rspec'
  gem 'rspec-rails'      # RSpec for Rails

  # Data generation
  gem 'factory_girl_rails' # Test data generator
  gem 'ffaker'             # Easily generate fake data

  # Use Pry and its extensions instead of IRB
  gem 'jazz_hands', github: 'nixme/jazz_hands',
                    branch: 'bring-your-own-debugger'
  gem 'pry-byebug'      # Pry navigation commands via debugger (formerly ruby-debug)
end

group :development do
  gem 'quiet_assets' # Turns off assets pipeline log

  # Better Errors: Replaces the standard Rails error page with a more useful one
  gem 'better_errors'
  gem 'binding_of_caller' # Needed by better_errors to enable html console

  gem 'xray-rails' # Reveals your UI's bones with Cmd-X/Ctrl-X

  # Rails application preloader
  gem 'spring'
  gem 'spring-commands-rspec' # Commands for RSpec

  # Guard: automatically run commands when files are changed
  gem 'guard'
  gem 'guard-rspec', require: false      # Automatically run tests
  gem 'terminal-notifier-guard'          # Mac OS X User Notifications for Guard
  gem 'guard-livereload', require: false # Automatically reload your browser when 'view' files are modified
  gem 'guard-bundler'                    # Automatically install/update gem bundle when needed
  gem 'guard-annotate'                   # Automatically run the annotate gem when needed
  gem 'guard-migrate'                    # Automatically run migrations when they are edited

  gem 'rerun', require: false # Restarts an app when the filesystem changes

  gem 'rack-livereload' # Enable LiveReload in Rails

  gem 'rb-fsevent', require: false # FSEvents API with signals handled

  gem 'rubocop', require: false # A robust Ruby code analyzer, based on the community Ruby style guide

  gem 'rip_hashrocket', # Replace hashrockets (=>) automatically
       github:  'jmuheim/rip_hashrocket',
       require: false

  gem 'capybara' # Acceptance test framework for web applications

  gem 'rails-footnotes' # Every Rails page has footnotes that gives information about your application

  gem 'mina', require: false # Really fast deployer and server automation tool

  gem 'i18n_yaml_sorter' # A I18n YAML deep sorter that will keep your locales organized
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

  gem 'capybara-screenshot' # Automatically save screen shots when a scenario fails

  gem 'rspec-cells' # Test cells using RSpec

  gem 'headhunter' # Automagically validates all HTML and CSS during feature tests

  gem 'coveralls', require: false

  gem 'i18n-tasks'
end

group :production do
  gem 'mysql2' # Use MySQL as the database for Active Record
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]