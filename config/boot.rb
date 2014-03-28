# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Change default port of development server, see http://stackoverflow.com/questions/18103316
require 'rails/commands/server'
module DefaultOptions
  def default_options
    super.merge!(Port: 3001)
  end
end
Rails::Server.send(:prepend, DefaultOptions)
