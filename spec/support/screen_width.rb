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
    original_width = page.driver.execute_script('return window.innerWidth')
    original_height = page.driver.execute_script('return window.innerHeight')

    Capybara.page.current_window.resize_to desired_width(screen), 10000

    if block_given?
      yield
      Capybara.page.current_window.resize_to original_width, original_height
    end
  end
end

RSpec.configure do |config|
  config.include ScreenWidth, type: :feature
end
