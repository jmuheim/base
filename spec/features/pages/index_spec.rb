require 'rails_helper'

describe 'Listing pages' do
  before { login_as(create :admin) }

  it 'displays pages' do
    @page = create :page
    visit pages_path

    expect(page).to have_title 'Pages - Base'
    expect(page).to have_active_navigation_items 'Admin', 'List of Pages'
    expect(page).to have_breadcrumbs 'Base', 'Pages'
    expect(page).to have_headline 'Pages'

    within dom_id_selector(@page) do
      expect(page).to have_css '.title a',          text: 'Page test title'
      expect(page).to have_css '.navigation_title', text: 'Page test navigation title'
      expect(page).to have_css '.content',          text: 'Page test content'
      expect(page).to have_css '.notes',            text: 'Page test notes'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    within 'div.actions' do
      expect(page).to have_css 'h2', text: 'Actions'
      expect(page).to have_link 'Create Page'
    end
  end
end
