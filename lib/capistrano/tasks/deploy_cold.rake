# Capistrano does not seem to offer any way to create the database, nor does it offer any way to load its schema. On every deployment, it runs the migrations, and expects the database and tables to exist alreay.
#
# This custom task mimicks a normal deploy, but instead of migrating the database, it loads the schema. Run it the very first time you deploy your application. For any further deployment, use the default deploy task.
#
# See https://stackoverflow.com/questions/1329778/dbschemaload-vs-dbmigrate-with-capistrano#answer-25098985

desc 'Deploy app for first time'
task :deploy_cold do
  invoke 'deploy:starting'
  invoke 'deploy:started'
  invoke 'deploy:updating'
  invoke 'bundler:install'
  invoke 'db_schema_load' # This replaces deploy:migrations
  invoke 'deploy:compile_assets'
  invoke 'deploy:normalize_assets'
  invoke 'deploy:publishing'
  invoke 'deploy:published'
  invoke 'deploy:finishing'
  invoke 'deploy:finished'
end

desc 'Load DB Schema'
task :db_schema_load do
  on roles(:db) do
    within release_path do
      with rails_env: (fetch(:rails_env) || fetch(:stage)) do
        execute :rake, 'db:schema:load'
      end
    end
  end
end
