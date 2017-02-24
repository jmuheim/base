module NestedAttributesHelper
  def get_latest_nested_field_id(nested_name)
    selector = "[id^='#{nested_name}_attributes_']"
    field = page.all(selector).last or raise "Couldn't find element with selector #{selector}"

    field[:id].match(/^#{nested_name}_attributes_(\d+)_/)[1]
  end
end

RSpec.configure do |config|
  config.include NestedAttributesHelper, type: :feature
end