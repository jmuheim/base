require 'rails_helper'

describe 'Showing app config' do
  before do
    @admin = create :user, :admin
    login_as(@admin)

    @app_config = AppConfig.instance
  end

  it 'displays an app config' do
    @app_config.projects_default_description = 'App config test projects default description'
    @app_config.save!

    visit root_path
    click_link 'Application configuration'

    expect(page).to have_title 'Application configuration - A4AA 2.0'
    expect(page).to have_active_navigation_items 'Application configuration'
    expect(page).to have_breadcrumbs 'A4AA 2.0', 'Application configuration'
    expect(page).to have_headline 'Application configuration'

    within dom_id_selector(@app_config) do
      expect(page).to have_css '.organisation_name', text: '«Access for all»'
      expect(page).to have_css '.organisation_abbreviation', text: 'A4A'
      expect(page).to have_css '.organisation_url', text: 'http://www.access-for-all.ch/'

      within '.projects_default_description' do
        expect(page).to have_css 'h2', text: 'Default description for projects'
        expect(page).to have_css 'pre', text: 'App config test projects default description'
      end

      within '.additional_information' do
        expect(page).to have_css '.created_at', text: 'Mon, 15 Jun 2015 14:33:52 +0200'
        expect(page).to have_css '.updated_at', text: 'Mon, 15 Jun 2015 14:33:52 +0200'
      end

      within '.actions' do
        expect(page).to have_css 'h2', text: 'Actions'

        expect(page).to     have_link 'Edit'
        expect(page).not_to have_link 'Delete'
        expect(page).not_to have_link 'Create '
        expect(page).not_to have_link 'List of Application configuration'
      end
    end
  end

  # The more thorough tests are implemented for pages#show. As we simply render the same partial here, we just make sure the container is there.
  it 'displays versions', versioning: true do
    visit app_config_path(@app_config)

    within '.versions' do
      expect(page).to have_css  'h2', text: 'Versions (1)'
    end
  end
end
