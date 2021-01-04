module Autocomplete
  # See https://stackoverflow.com/questions/65256501/how-to-find-out-within-a-capybara-spec-whether-js-is-active
  def select_from_autocomplete(label, id, js = false)
    input_id = "#{id}_filter"

    if js
      # Clear any previous selection
      find("##{input_id}").send_keys :escape
    end

    fill_in input_id, with: label # Open autocomplete and filter
    find('label', text: label, visible: js).click # Capybara's click() doesn't work because the input is visually hidden! And we have to use visible = false because when JS is off, the elements wouldn't be found.
  end
end

RSpec.configure do |config|
  config.include Autocomplete, type: :feature
end
