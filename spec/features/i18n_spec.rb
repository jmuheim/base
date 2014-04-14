require 'spec_helper'

describe 'I18n' do
  it 'uses english as default language' do
    visit root_path

    expect(page).to have_content 'Welcome'
  end

  it 'offers contents in english' do
    visit root_path(locale: :en)

    expect(page).to have_content 'Welcome'

    within '#language_selector' do
      expect(page).to     have_css 'li.en.active'
      expect(page).not_to have_css 'li.de.active'
    end
  end

  it 'offers contents in german' do
    visit root_path(locale: :de)

    expect(page).to have_content 'Willkommen'

    within '#language_selector' do
      expect(page).not_to have_css 'li.en.active'
      expect(page).to     have_css 'li.de.active'
    end
  end
end
