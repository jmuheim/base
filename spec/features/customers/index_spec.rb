require 'rails_helper'

describe 'Listing customers' do
  before do
    @customer = create :customer

    login_as(create :admin)
  end

  it 'displays customers' do
    visit customers_path

    expect(page).to have_title 'Customer - Project Manager'
    expect(page).to have_active_navigation_items 'Customer', 'List of Customer'
    expect(page).to have_breadcrumbs 'Project Manager', 'Customer'
    expect(page).to have_headline 'Customer'

    within dom_id_selector(@customer) do
      expect(page).to have_css '.name a',          text: 'Customer test name'
      expect(page).to have_css '.address pre',     text: 'Customer test address'
      expect(page).to have_css '.description pre', text: 'Customer test description'
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    within 'div.actions' do
      expect(page).to have_css 'h2', text: 'Actions'
      expect(page).to have_link 'Create Customer'
    end
  end
end
