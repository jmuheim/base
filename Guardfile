# A sample Guardfile
# More info at https://github.com/guard/guard#readme

require 'active_support/inflector'

guard :livereload, port: 35729 do
  watch(%r{app/(cells|views)/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})

  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
  watch(%r{(app/assets/stylesheets/globals)/.+\.css\.(sass|scss)}) { |m| "#{m[1]}/application.css.#{m[2]}" } # It's strange that this rule is needed, it should work without it, see http://blog.55minutes.com/2013/01/lightning-fast-sass-reloading-in-rails-32/#comment-1184644401
end

# TODO: Why is bundle exec needed? More infos here: http://stackoverflow.com/questions/22555324 and https://github.com/rails/spring/issues/277
guard :rspec, cmd: 'bundle exec spring rspec',
              failed_mode: :focus do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch('app/models/ability.rb')  { "spec/models/user_spec.rb" }

  # TODO: Rename to features!
  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})

  # Reload factory girl, see http://urgetopunt.com/2011/10/01/guard-factory-girl.html
  watch(%r{^spec/factories/(.+)\.rb$}) do |m|
    [
      "spec/models/#{m[1].singularize}_spec.rb",
      "spec/controllers/#{m[1]}_controller_spec.rb",

      # This is too slow
      # "spec/acceptance/#{m[1]}"
    ]
  end
end

guard :bundler do
  watch('Gemfile')
  # Uncomment next line if your Gemfile contains the `gemspec' command.
  # watch(/^.+\.gemspec/)
end

guard 'migrate', cmd:          'spring rake',
                 run_on_start: false,
                 test_clone:   true,
                 reset:        true,
                 seed:         true do
  watch(%r{^db/migrate/(\d+).+\.rb})
  watch('db/seeds.rb')
end

guard 'annotate', show_indexes:   true,
                  show_migration: true do
  watch( 'db/schema.rb' )

  # Uncomment the following line if you also want to run annotate anytime
  # a model file changes
  # watch( 'app/models/**/*.rb' )

  # Uncomment the following line if you are running routes annotation
  # with the ":routes => true" option
  # watch( 'config/routes.rb' )
end
