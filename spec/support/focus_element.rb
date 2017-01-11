module FocusElement
  def focus_element(selector)
    page.execute_script("$('#{selector}').focus()")
  end

  def unfocus_element(selector)
    page.execute_script("$('#{selector}').blur()")
  end

  def focused_element_id
    # In general, we use execute_script, not evaluate_script, as it's much faster!
    # See https://makandracards.com/makandra/12317-capybara-selenium-evaluate_script-might-freeze-your-browser-use-execute_script
    #
    # But in this specific case, evaluate_script seems to be needed.
    page.evaluate_script('document.activeElement.id')
  end
end

RSpec.configure do |config|
  config.include FocusElement, type: :feature
end
