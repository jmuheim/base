# Use `refresh_page` to reload the current page. Only works for GET requests!
# See http://makandracards.com/makandra/760-reload-the-page-in-your-cucumber-features
module RefreshPage
  def refresh_page
    visit [ current_path, page.driver.request.env['QUERY_STRING'] ].reject(&:blank?).join('?')
  end
end

RSpec.configure do |config|
  config.include RefreshPage, type: :feature
end
