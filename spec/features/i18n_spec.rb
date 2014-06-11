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

  it 'offers the possibility to switch languages' do
    visit root_path

    within '#language_chooser' do
      expect(page).to have_content 'Choose language' # Default language is english
      click_link 'Seite auf Deutsch anzeigen'
    end

    within '#language_chooser' do
      expect(page).to have_content 'Sprache wählen'
      click_link 'Show page in english'
    end

    within '#language_chooser' do
      expect(page).to have_content 'Choose language'
    end
  end
end
