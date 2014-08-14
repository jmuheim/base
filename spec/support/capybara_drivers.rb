Capybara.register_driver :chrome do |app|
  args = []
  args << '--disable-translate' # Remove the annoying translation suggestion on every page load
  Capybara::Selenium::Driver.new(app, browser: :chrome, args: args)
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_logger: WarningsSuppressor)
end

Capybara.javascript_driver = :poltergeist # use 'driver: :chrome' (like 'js: true') if you need the dev tools for specific specs