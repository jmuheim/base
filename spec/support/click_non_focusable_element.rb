module ClickNonFocusableElement
  # PhantomJS allowed this, Chromedriver does not (it only allows clicking focusable elements), so we need some hacky JavaScript for this.
  def click_non_focusable_element(selector)
    fail "Selector #{selector} doesn't exist" unless page.has_css? selector
    page.execute_script("$('#{selector}').trigger('click')")
  end
end

RSpec.configure do |config|
  config.include ClickNonFocusableElement, type: :feature
end
