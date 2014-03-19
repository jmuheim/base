desc "Start development server (via rerun)"
task :server do
  sh "rerun --pattern '{Gemfile,Gemfile.lock,config/environment.rb,config/environments/development.rb,config/initializers/*.rb,lib/**/*.rb}' --no-growl -- rails s"
end
