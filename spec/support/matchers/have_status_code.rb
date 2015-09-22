RSpec::Matchers.define :have_status_code do |expected|
  match do |actual|
    actual_code == expected
  end

  failure_message do |actual|
    "expected that \"#{expected}\" would be the status code, but was \"#{actual_code}\""
  end

  def actual_code
    page.driver.status_code
  end
end
