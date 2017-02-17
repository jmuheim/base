# More info at https://github.com/guard/guard#readme

require 'active_support/inflector'

guard :shell do
  # Some problems with this approach (double reloading of livereload):
  # - http://stackoverflow.com/questions/28136107/guard-gem-pause-file-modification-within-guardfile-for-execution-of-a-block
  # - http://stackoverflow.com/questions/28136122/guard-gem-run-some-code-at-startup-or-shutdown
  # watch %r{app/\w+/(.+\.(html|rb)).*} do |m|
  #   n m[0], 'Changed'
  #   `i18n-tasks add-missing -v 'TRANSLATE: %{value}'`
  # end

  # watch 'Gemfile.lock' do |m|
  #   `spring reload`
  # end
end

guard :livereload, port: 35729 do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/(helpers|inputs)/.+\.rb})
  watch('config/routes.rb')
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  watch('app/models/ability.rb')

  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(sass|coffee|css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
end

# TODO: Why is bundle exec needed? More infos here: http://stackoverflow.com/questions/22555324 and https://github.com/rails/spring/issues/277
guard :rspec, cmd: 'bin/rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/features/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch('app/models/ability.rb')  { "spec/models/user_spec.rb" }

  # TODO: Rename to features!
  # Turnip features and steps
  watch(%r{^spec/features/(.+)\.feature$})

  # Reload factory girl, see http://urgetopunt.com/2011/10/01/guard-factory-girl.html
  watch(%r{^spec/factories/(.+)\.rb$}) do |m|
    [ "spec/models/#{m[1].singularize}_spec.rb",
      "spec/controllers/#{m[1]}_controller_spec.rb"
    ]
  end
end

guard :bundler do
  watch('Gemfile')
  # Uncomment next line if your Gemfile contains the `gemspec' command.
  # watch(/^.+\.gemspec/)
end

guard :migrate, cmd:          'spring rake',
                run_on_start: false do
  watch(%r{^db/migrate/(\d+).+\.rb})
  watch('db/seeds.rb')
end
