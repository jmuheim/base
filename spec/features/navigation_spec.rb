require 'spec_helper'

describe 'Navigation' do
  it 'offers a link to the home page' do
    visit root_path

    expect(page).to have_link 'Gemeinschaften'
  end

  it 'offers a link to the about page' do
    visit root_path

    expect(page).to have_link 'About'
  end
end
