require 'spec_helper'

describe 'I18n' do
  it 'uses english as default language' do
    visit root_path

    expect(page).to have_content 'Welcome'
  end

  it 'offers contents in english' do
    visit root_path(locale: :en)

    expect(page).to have_content 'Welcome'
  end

  it 'offers contents in german' do
    visit root_path(locale: :de)

    expect(page).to have_content 'Willkommen'
  end

  it 'offers the possibility to switch languages using the language chooser', js: true do
    visit root_path

    within '#language_chooser' do
      expect(page).to have_css '.bfh-selectbox-toggle', text: 'English'
    end
    expect(page).to have_content 'Welcome'

    within '#language_chooser' do
      click_link 'English' # Open dropdown
      click_link 'Deutsch' # Choose option
      expect(page).to have_css '.bfh-selectbox-toggle', text: 'Deutsch'
    end
    expect(page).to have_content 'Willkommen'
  end
end
