# Treat .feature files as RSpec files when running `rake spec`.
# https://github.com/rspec/rspec-rails/issues/538
# if defined? RSpec
#   task(:spec).clear
# 
#   desc "Run all specs in spec directory (excluding plugin specs)"
#   RSpec::Core::RakeTask.new(spec: 'db:test:prepare') do |t|
#     t.pattern = './spec/**/*{_spec.rb,.feature}'
#   end
# 
#   namespace :spec do
#     desc "Run the code examples in spec/acceptance"
#     RSpec::Core::RakeTask.new(acceptance: 'db:test:prepare') do |t|
#       t.pattern = './spec/acceptance/**/*.feature'
#     end
#   end
# end
