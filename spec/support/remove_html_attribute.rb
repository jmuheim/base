module RemoveHtmlAttribute
  def remove_html_attribute(id, selector)
    fail "Selector #{id} doesn't exist!" unless page.has_css? id
    page.execute_script("$('#{id}').removeAttr('#{selector}')")
  end
end

RSpec.configure do |config|
  config.include RemoveHtmlAttribute, type: :feature
end
