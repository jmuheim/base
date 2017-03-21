require 'rails_helper'

describe 'Showing the home page' do
  before { visit root_path }

  it 'displays a welcome message' do
    expect(page).to have_title 'Welcome to Base'
    expect(page).to have_breadcrumbs 'Base'
    expect(page).to have_headline 'Welcome to Base'
  end
end
