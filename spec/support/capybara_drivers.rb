require 'webdrivers/chromedriver'

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :headless_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: { browser: 'ALL' })
  opts = Selenium::WebDriver::Chrome::Options.new

  chrome_args = %w[--headless --no-sandbox --disable-gpu --window-size=1920,1080 --remote-debugging-port=9222]
  chrome_args.each { |arg| opts.add_argument(arg) }
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts, desired_capabilities: caps)
end

Capybara.javascript_driver = :headless_chrome # use 'driver: :chrome' (like 'js: true') if you need the dev tools for specific specs
