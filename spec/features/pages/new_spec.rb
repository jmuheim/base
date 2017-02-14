require 'rails_helper'

describe 'Creating page' do
  before { login_as create :admin, :scrooge }

  it 'creates a page' do
    visit new_page_path

    expect(page).to have_title 'Create Page - Base'
    expect(page).to have_active_navigation_items 'Admin', 'Create Page'
    expect(page).to have_breadcrumbs 'Base', 'Pages', 'Create'
    expect(page).to have_headline 'Create Page'

    fill_in 'page_title',            with: 'new title'
    fill_in 'page_navigation_title', with: 'new navigation title'
    fill_in 'page_content',          with: 'new content'
    fill_in 'page_notes',            with: 'new notes'

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Create Page'
      expect(page).to have_link 'List of Pages'
    end

    click_button 'Create Page'

    expect(page).to have_flash 'Page was successfully created.'
  end
end