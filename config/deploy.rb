require 'mina/rails'
require 'mina/bundler'
require 'mina/git'
require 'mina/puma'

set :app_name,      'base'                            # Short, slug-like application name, e.g. `mcp` or `my-cool-project`
set :domain,        'sirius.uberspace.de'             # Domain to SSH to, e.g. `sirius.uberspace.de`
set :deploy_to,     '/home/base/rails'                # E.g. `/home/mcp/rails`
set :repository,    'git@github.com:jmuheim/base.git' # E.g. `git@github.com:jmuheim/mcp.git`
set :user,          'base'                            # SSH user, e.g. `mcp`
set :puma_port,     3001 # Should be the same as `app_port` in your secrets

set :branch,        ENV['branch'] || `git rev-parse --abbrev-ref HEAD`.strip
set :forward_agent, true

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` adds `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
set :shared_dirs, fetch(:shared_dirs, []).push('public/uploads', 'tmp/sockets', 'tmp/pids')
set :shared_files, fetch(:shared_files, []).push('config/secrets.yml')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  comment "Be sure to create #{fetch(:shared_path)}/config/secrets.yml!"

  command %{gem install bundler}
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  invoke :'git:ensure_pushed'

  deploy do
    comment "Deploying #{fetch(:app_name)} to #{fetch(:domain)}:#{fetch(:deploy_to)}"

    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'

    # This loads the DB schema, runs migrations, and executes the seeds.
    # https://stackoverflow.com/questions/58372477
    # invoke :'rails:db_schema_load'      # Uncomment temporarily for first deployment!
    invoke :'rails:db_migrate'
    # command %{#{fetch(:rails)} db:seed} # Uncomment temporarily for first deployment!

    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'puma:hard_restart'

      # in_path(fetch(:current_path)) do
      #   Do more stuff...
      # end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end
