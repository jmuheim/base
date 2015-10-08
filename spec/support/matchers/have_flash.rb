RSpec::Matchers.define :have_flash do |expected|
  chain :of_type do |type|
    @type = type
  end

  match do |actual|
    @type ||= 'notice'

    page.has_css? "#{css_selector}.flash-#{@type}", text: expected
  end

  failure_message do |actual|
    "expected that \"#{expected}\" would be the flash, but was \"#{actual_text}\""
  end

  def css_selector
    '#headline #flash'
  end

  def actual_text
    actual.find(css_selector).text
  end
end
