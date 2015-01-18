require 'rails_helper'

describe 'Showing about page' do
  before { visit page_path('about') }

  it 'displays a welcome message' do
    within 'main' do
      expect(page).to have_content 'About Base'
    end
  end
end
