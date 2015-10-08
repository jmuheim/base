RSpec::Matchers.define :have_headline do |expected|
  match do |actual|
    page.has_css? css_selector, text: expected
  end

  failure_message do |actual|
    "expected that \"#{expected}\" would be the headline, but was \"#{actual_text}\""
  end

  def css_selector
    '#headline h1'
  end

  def actual_text
    actual.find(css_selector).text
  end
end
