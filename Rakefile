# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
Base::Application.load_tasks

task :'assets:precompile' => :'bower:install' # Needed at the moment, see https://github.com/42dev/bower-rails/issues/82
