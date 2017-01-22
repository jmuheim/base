module ScrollBy
  def scroll_by(x, y)
    page.execute_script "window.scrollBy(#{x}, #{y})"
  end
end

RSpec.configure do |config|
  config.include ScrollBy, type: :feature
end
