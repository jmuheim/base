# See https://github.com/mattheworiordan/capybara-screenshot/issues/211
Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end
