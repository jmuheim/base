require 'rails_helper'

describe 'Showing the home page' do
  before { visit page_path('home') }

  it 'displays a welcome message' do
    within 'main' do
      expect(page).to have_content 'Welcome to Base!'
    end
  end
end
