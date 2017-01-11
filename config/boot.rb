ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Change default port of development server, see http://stackoverflow.com/questions/18103316
require 'rails/commands/server'
module DefaultOptions
  def default_options
    super.merge!(Port: 3001) # As long as the config in config/puma.doesn't work, we keep this here (see https://github.com/rails/rails/issues/24435)
  end
end
Rails::Server.send(:prepend, DefaultOptions)
