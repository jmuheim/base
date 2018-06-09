require_relative 'boot'

ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder' # Use SimpleForm with Ransack

# Don't require 'rails/all' because we use RSpec instead of rails/test_unit.
# See http://stackoverflow.com/questions/20872895.
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'tilt/pandoc'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Base
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Zurich'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:de, :en]

    config.sass.preferred_syntax = :sass

    config.generators do |g|
      g.template_engine :slim
    end

    config.action_dispatch.rescue_responses.merge! 'CanCan::AccessDenied' => :forbidden

    # Always raise error on unpermitted parameters
    # config.action_controller.action_on_unpermitted_parameters = :raise

    # Automatically convert boolean values to integer using sqlite3
    config.active_record.sqlite3.represent_boolean_as_integer = true if Rails.version >= '5.1.0' && config.active_record.sqlite3.present?
  end
end

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:              Rails.application.secrets.smtp_address,
  port:                 Rails.application.secrets.smtp_port,
  domain:               Rails.application.secrets.smtp_domain,
  user_name:            Rails.application.secrets.smtp_user_name,
  password:             Rails.application.secrets.smtp_password,
  authentication:       Rails.application.secrets.smtp_authentication,
  enable_starttls_auto: Rails.application.secrets.smtp_enable_starttls_auto,
  ssl:                  Rails.application.secrets.smtp_ssl
}
