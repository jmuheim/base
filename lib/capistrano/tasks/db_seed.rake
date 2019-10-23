# Custom task to seed the database. If you need this, simply run it after first deploy (`cap production deploy_cold`).
#
# See https://stackoverflow.com/questions/1329778/dbschemaload-vs-dbmigrate-with-capistrano#answer-25098985

desc 'Load DB Seed'
task :db_seed do
  on roles(:db) do
    within release_path do
      with rails_env: (fetch(:rails_env) || fetch(:stage)) do
        execute :rake, 'db:seed'
      end
    end
  end
end
