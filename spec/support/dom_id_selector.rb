# Use `dom_id_selector(model)` for e.g. `within ...` contexts in Capybara specs.
# Inspired by https://gist.github.com/nruth/1264245
module DomIdSelector
  def dom_id_selector(model)
    "##{ActionController::RecordIdentifier.dom_id(model)}"
  end
end

RSpec.configure do |config|
  config.include DomIdSelector, type: :feature
end
