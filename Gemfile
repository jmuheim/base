source 'https://rubygems.org'

gem 'rails', '~> 5.2'

gem 'puma' # Use Puma as the app server

gem 'rails-i18n' # Locale data

gem 'mobility' # Pluggable Ruby translation framework

gem 'slim-rails' # Awesome template language that replaces ERB

gem 'uglifier' # Use Uglifier as compressor for JavaScript assets

gem 'coffee-rails' # Use CoffeeScript for .js.coffee assets and views

gem 'sass-rails' # Use Sass for stylesheets

gem 'compass-rails', '~> 3.1' # Compass framework

gem 'bootstrap-sass' # Sleek, intuitive, and powerful front-end framework

gem 'font-awesome-rails' # The iconic font and CSS toolkit

gem 'validate_url' # URL Validation for Rails

gem 'validates_email_format_of' # Validate e-mail addreses against RFC 2822 and RFC 3696

gem 'humanizer' # Very simple captcha

gem 'acts_as_tree' # Extends ActiveRecord to add simple support for organizing items into parent–children relationships

gem 'acts_as_list' # An ActiveRecord plugin for managing lists

gem 'premailer-rails' # CSS styled emails without the hassle

# jQuery
gem 'jquery-rails'

# Flexible authentication solution
gem 'devise'
gem 'devise-i18n' # Translations

gem 'cancancan' # Authorization library which restricts what resources a given user is allowed to access

gem 'responders' # A set of Rails responders

gem 'simple_form' # Forms made easy for Rails

gem 'gaffe' # Handles Rails error pages in a clean, simple way

gem 'cocoon' # Dynamic nested forms made easy

gem 'validates_timeliness' # Date and time validation plugin for ActiveModel and Rails

gem 'strip_attributes', git: 'https://github.com/jmuheim/strip_attributes.git' # Automatically strips all attributes of leading and trailing whitespace (or nilify if blank)

gem 'enumerize' # Enumerated attributes with I18n

gem 'paper_trail' # Track changes to your models' data. Good for auditing or versioning.

# Classier solution for file uploads for Rails
gem 'carrierwave', '< 2'
gem 'carrierwave-base64' # Upload files encoded as base64 to carrierwave

gem 'mini_magick' # Mini replacement for RMagick

gem 'fancybox2-rails' # Fancybox (lightbox clone)

gem 'slugify' # Turn a string into its alphanumerical dashed equivalent

gem 'pandoc-ruby' # Markdown parser and format converter (from/to Markdown, HTML, Docx, PDF, Epub, ODT...)

gem 'ransack' # Object-based searching

gem 'actionview-encoded_mail_to' # Rails mail_to helper with obfuscation

gem 'wannabe_bool' # Converts strings, integers, etc. intuitively to boolean values

gem 'mysql2' # Use MySQL as the database for Active Record

group :doc do
  gem 'sdoc', require: false # bundle exec rake doc:rails generates the API under doc/api.
end

group :development, :test do
  # Testing tool for the Ruby programming language
  gem 'rspec'
  gem 'rspec-rails' # RSpec for Rails

  gem 'factory_bot_rails' # Test data generator

  # Use Pry and its extensions to debug
  gem 'pry-rails' # Rails >= 3 pry initializer
  gem 'awesome_print' # Pretty print your Ruby objects with style
  gem 'pry-byebug'  # Pry navigation commands via debugger (formerly ruby-debug)
end

group :development do
  gem 'web-console' # Access an IRB console by using <%= console %> anywhere in the code

  gem 'listen' # Listens to file modifications and notifies you about the changes

  # Better Errors: Replaces the standard Rails error page with a more useful one
  gem 'better_errors'
  # gem 'binding_of_caller' # Adds a REPL console to error pages (disabled, because it's very slow, see https://github.com/charliesome/better_errors/issues/341)

  gem 'xray-rails' # Reveals your UI's bones with Cmd-X/Ctrl-X

  # Rails application preloader
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'spring-commands-rspec' # Commands for RSpec

  # Guard: automatically run commands when files are changed
  gem 'guard'
  gem 'guard-rspec', require: false      # Automatically run tests
  gem 'terminal-notifier-guard'          # Mac OS X User Notifications for Guard
  gem 'guard-livereload', require: false # Automatically reload your browser when 'view' files are modified
  gem 'guard-bundler'                    # Automatically install/update gem bundle when needed
  gem 'guard-migrate'                    # Automatically run migrations when they are edited
  gem 'guard-shell'                      # Automatically run shell commands

  gem 'rerun', require: false # Restarts an app when the filesystem changes

  gem 'rack-livereload' # Enable LiveReload in Rails

  gem 'rb-fsevent', require: false # FSEvents API with signals handled

  gem 'rubocop', require: false # A robust Ruby code analyzer, based on the community Ruby style guide

  gem 'capybara' # Acceptance test framework for web applications

  gem 'rails-footnotes', git: 'https://github.com/I-de-ya/rails-footnotes.git' # Every Rails page has footnotes that gives information about your application

  # Really fast deployer and server automation tool
  gem 'mina', require: false
  gem 'mina-ng-puma', require: false

  gem 'i18n_yaml_sorter' # A I18n YAML deep sorter that will keep your locales organized
end

group :test do
  gem 'rspec-collection_matchers' # Collection cardinality matchers

  gem 'respec', require: false # Allows to rerun failed specs (first do `respec` to run all, then `respec f` or `respec 123` to run failed)

  gem 'fuubar' # The instafailing RSpec progress bar formatter

  gem 'email_spec' # Collection of RSpec matchers for testing email

  gem 'shoulda-matchers' # Collection of RSpec matchers

  gem 'database_cleaner' # Resets test database after each test

  # Capybara - Headless, JavaScript-executing browser for Selenium
  gem 'poltergeist' # PhantomJS driver for Capybara
  gem 'launchy'              # Use `save_and_open_page` in request tests to automatically open a browser
  gem 'selenium-webdriver'   # Selenium webdriver (needed to use Chrome driver)

  gem 'capybara-screenshot' # Automatically save screen shots when a scenario fails

  gem 'i18n-tasks' # Manage translation and localization with static analysis

  gem 'simplecov'
  gem 'codeclimate-test-reporter'
end

group :production do
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
