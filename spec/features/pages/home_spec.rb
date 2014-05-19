require 'spec_helper'

describe 'Showing the home page' do
  it 'displays a welcome message' do
    visit root_path

    expect(page).to have_content 'Welcome to Base!'
  end
end
