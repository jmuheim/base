Capybara.register_driver :chrome do |app|
  args = []
  args << '--disable-translate' # Remove the annoying translation suggestion on every page load
  Capybara::Selenium::Driver.new(app, browser: :chrome, args: args)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.javascript_driver = :headless_chrome # use 'driver: :chrome' (like 'js: true') if you need the dev tools for specific specs