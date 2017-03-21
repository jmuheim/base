module FeatureSpecVisitDeletePathHelper
  def visit_delete_path_for(resources, resource_path = nil)
    resources = [resources] unless resources.is_a?(Array)
    resource_path ||= "#{resources.map { |resource| resource.class.to_s.underscore }.join('_')}_path"

    # Send delete request using capybara, see http://makandracards.com/makandra/18023-trigger-a-delete-request-with-capybara
    case page.driver
    when Capybara::RackTest::Driver
      page.driver.submit :delete, send(resource_path, *resources), {}
    else # e.g. Capybara::Selenium::Driver
      visit send(resource_path, resources, method: :delete)
    end
  end
end

RSpec.configure do |config|
  config.include FeatureSpecVisitDeletePathHelper, type: :feature
end
