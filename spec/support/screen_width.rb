# Use `dom_id_selector(model)` for e.g. `within ...` contexts in Capybara specs.
# Inspired by https://gist.github.com/nruth/1264245
module ScreenWidth
  # These values must reflect those in Twitter Bootstrap (see _variables.scss)
  EXTRA_SMALL_SCREEN_WIDTH = 767
  SMALL_SCREEN_WIDTH = 768
  MEDIUM_SCREEN_WIDTH = 992
  LARGE_SCREEN_WIDTH = 1200

  def desired_width(screen)
    case screen
    when :xs
     EXTRA_SMALL_SCREEN_WIDTH
    when :sm
     SMALL_SCREEN_WIDTH
    when :md
     MEDIUM_SCREEN_WIDTH
    when :lg
     LARGE_SCREEN_WIDTH
    else
     raise "Invalid option #{screen} passed"
    end
  end

  def screen_width(screen, &block)
    original_width = page.driver.evaluate_script('window.innerWidth')
    original_height = page.driver.evaluate_script('window.innerHeight')

    resize_window desired_width(screen), 500

    if block_given?
      yield
      resize_window original_width, original_height
    end
  end

  def resize_window(width, height)
    if page.driver.browser.respond_to? :manage # Selenium needs this...!?
      page.driver.browser.manage.window.resize_to(width, height)
    else
      page.driver.resize_window(width, height)
    end
  end
end

RSpec.configure do |config|
  config.include ScreenWidth, type: :feature
end
