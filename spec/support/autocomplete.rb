module Autocomplete
  def select_from_autocomplete(label, id)
    fill_in "#{id}_filter", with: label # Open autocomplete and filter
    find('label', text: label).click    # Capybara's choose() doesn't work because the input is visually hidden! And we have to use visible: false because when JS is off, the elements wouldn't be found.
  end
end

RSpec.configure do |config|
  config.include Autocomplete, type: :feature
end
