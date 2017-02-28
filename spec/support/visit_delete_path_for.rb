module FeatureSpecVisitDeletePathHelper
  def visit_delete_path_for(resource, resource_path = nil)
    raise "Resource must not be nil" if resource.nil?
    resource_path ||= "#{resource.resource_class}_path"

    # Send delete request using capybara, see http://makandracards.com/makandra/18023-trigger-a-delete-request-with-capybara
    case page.driver
    when Capybara::RackTest::Driver
      page.driver.submit :delete, send(resource_path, resource), {}
    else # e.g. Capybara::Selenium::Driver
      visit send(resource_path, resource, method: :delete)
    end
  end
end

RSpec.configure do |config|
  config.include FeatureSpecVisitDeletePathHelper, type: :feature
end
