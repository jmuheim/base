# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
Base::Application.load_tasks

# http://stackoverflow.com/questions/30028315/want-to-seed-with-rails-env-production-but-getting-nameerror-uninitialized-con
unless Rails.env.production?
  # Fuubar has problems at the moment, see https://github.com/thekompanee/fuubar/issues/84
  task(:default).clear
  task default: :'spec:fuubar'

  namespace :spec do
    desc 'Run all specs in spec directory (with Fuubar formatter)'
    RSpec::Core::RakeTask.new(:fuubar) do |task|
      task.rspec_opts = [task.rspec_opts.to_s, '--color --format Fuubar'].compact.join ' '
    end
  end
end
