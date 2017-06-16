Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Insert before BetterErrors::Middleware so LiveReload keeps reloading after
  # an error, see https://github.com/guard/guard-livereload/issues/94
  # Notice: BetterErrors::Middleware is injected as an engine, so it's not
  # available at this point, so we just insert before Rack::Lock which is nearly
  # at the top of the stack.
  # More info also here: https://github.com/johnbintz/rack-livereload/issues/73
  config.middleware.insert_before ActionDispatch::DebugExceptions, Rack::LiveReload, no_swf:           true,
                                                                                     live_reload_port: 35576

  # TODO: This should be retrieved from DefaultOptions, see http://stackoverflow.com/questions/3842818#comment46921326_23489706
  config.action_mailer.default_url_options = {host: 'localhost:3050'}

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
