source 'https://rubygems.org'

gem 'rails', '~> 5.0.1'

gem 'puma', '~> 3.0' # Use Puma as the app server

gem 'rails-i18n' # Locale data

gem 'slim-rails' # Awesome template language that replaces ERB

gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets

gem 'coffee-rails', '~> 4.2' # Use CoffeeScript for .js.coffee assets and views

gem 'sass-rails', '~> 5.0' # Use Sass for stylesheets

gem 'compass-rails' # Compass framework

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'bootstrap-sass' # Sleek, intuitive, and powerful front-end framework

gem 'font-awesome-rails' # The iconic font and CSS toolkit

gem 'acts_as_tree' # Extends ActiveRecord to add simple support for organizing items into parent–children relationships

gem 'acts_as_list' # An ActiveRecord plugin for managing lists

# jQuery
gem 'jquery-rails'
gem 'jquery-ui-rails' # jQuery UI components

gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# Flexible authentication solution
gem 'devise'
gem 'devise-i18n' # Translations

gem 'cancancan' # Authorization library which restricts what resources a given user is allowed to access

gem 'rolify' # Manage roles of users

gem 'responders' # A set of Rails responders

gem 'simple_form' # Forms made easy for Rails

gem 'gaffe' # Handles Rails error pages in a clean, simple way

gem 'cocoon' # Dynamic nested forms made easy

gem 'validates_timeliness' # Date and time validation plugin for ActiveModel and Rails

gem 'strip_attributes' # Automatically strips all attributes of leading and trailing whitespace (or nilify if blank)

gem 'enumerize' # Enumerated attributes with I18n

gem 'rails_admin' # Rails Admin: engine that provides an easy-to-use interface for managing data

gem 'paper_trail', '>= 4.0.0.rc' # Track changes to your models' data. Good for auditing or versioning.

# Classier solution for file uploads for Rails
gem 'carrierwave'
gem 'carrierwave-base64', '>= 2.5' # Upload files encoded as base64 to carrierwave

gem 'mini_magick' # Mini replacement for RMagick

gem 'fancybox2-rails' # Fancybox (lightbox clone)

gem 'slugify' # Turn a string into its alphanumerical dashed equivalent

gem 'pandoc-ruby' # Markdown parser and format converter (from/to Markdown, HTML, Docx, PDF, Epub, ODT...)

gem 'ransack' # Object-based searching

gem 'draper', '3.0.0.pre1' # Decorators/View-Models for Rails Applications

gem 'actionview-encoded_mail_to' # Rails mail_to helper with obfuscation

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw] # Timezone Data for TZInfo (needed when run on Microsoft Windows, see https://github.com/tzinfo/tzinfo/wiki/Resolving-TZInfo::DataSourceNotFound-Errors)

gem 'wannabe_bool' # Converts strings, integers, etc. intuitively to boolean values

group :doc do
  gem 'sdoc', require: false # bundle exec rake doc:rails generates the API under doc/api.
end

group :development, :test do
  # Testing tool for the Ruby programming language
  gem 'rspec'
  gem 'rspec-rails' # RSpec for Rails

  gem 'sqlite3' # Use SQLite as the database for Active Record

  # Data generation
  gem 'factory_girl_rails' # Test data generator
  gem 'ffaker'             # Easily generate fake data

  # Use Pry and its extensions to debug
  gem 'pry-rails' # Rails >= 3 pry initializer
  gem 'awesome_print' # Pretty print your Ruby objects with style
  gem 'pry-byebug'  # Pry navigation commands via debugger (formerly ruby-debug)
end

group :development do
  gem 'web-console', '>= 3.3.0' # Access an IRB console by using <%= console %> anywhere in the code

  gem 'listen', '~> 3.0.5' # Listens to file modifications and notifies you about the changes

  # Better Errors: Replaces the standard Rails error page with a more useful one
  gem 'better_errors'
  # gem 'binding_of_caller' # Adds a REPL console to error pages (disabled, because it's very slow, see https://github.com/charliesome/better_errors/issues/341)

  gem 'xray-rails' # Reveals your UI's bones with Cmd-X/Ctrl-X

  # Rails application preloader
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
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

  gem 'capybara', '>=2.2.0.beta' # Acceptance test framework for web applications

  gem 'rails-footnotes' # Every Rails page has footnotes that gives information about your application

  gem 'mina', require: false # Really fast deployer and server automation tool

  gem 'i18n_yaml_sorter' # A I18n YAML deep sorter that will keep your locales organized
end

group :test do
  gem 'rspec-collection_matchers' # Collection cardinality matchers

  gem 'respec', require: false # Allows to rerun failed specs (first do `respec` to run all, then `respec f` or `respec 123` to run failed)

  gem 'fuubar', '>= 2.0.0rc1' # The instafailing RSpec progress bar formatter

  gem 'email_spec' # Collection of RSpec matchers for testing email

  gem 'shoulda-matchers' # Collection of RSpec matchers

  gem 'database_cleaner' # Resets test database after each test

  # Capybara - Headless, JavaScript-executing browser for Selenium
  gem 'poltergeist'          # PhantomJS driver for Capybara
  gem 'launchy'              # Use `save_and_open_page` in request tests to automatically open a browser
  gem 'selenium-webdriver'   # Selenium webdriver (needed to use Chrome driver)

  gem 'capybara-screenshot' # Automatically save screen shots when a scenario fails

  gem 'i18n-tasks' # Manage translation and localization with static analysis

  gem 'simplecov'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end

group :production do
  # Use specific version because of this bug: https://github.com/rails/rails/issues/21544
  gem 'mysql2', '>= 0.3.18' # Use MySQL as the database for Active Record
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
