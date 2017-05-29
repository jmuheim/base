require 'rails_helper'

describe 'Page title, headline and flash' do
  it 'displays the page title and the headline on the home page' do
    visit root_path

    expect(page).to have_title 'Welcome to Base!'
    expect(page).to have_css 'main h1', text: 'Welcome to Base!'
  end

  it 'displays the page title and the headline on other pages' do
    visit page_path(create :page, creator: create(:user))

    expect(page).to have_title 'Page test title - Base'
    expect(page).to have_css 'main h1', text: 'Page test title'
  end

  context 'with flash' do
    it 'displays the flash in the page title and content' do
      visit root_path
      click_button 'Sign in' # Trigger validation error

      expect(page).to have_title 'Alert: Invalid login or password. Sign in - Base'
      within 'main' do
        expect(page).to have_css 'h1', text: 'Sign in'
        expect(page).to have_content 'Alert: Invalid login or password'
      end
    end
  end
end
