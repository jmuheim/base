require 'rails_helper'

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

  it 'sets the html language' do
    visit root_path

    expect(page).to have_css 'html[lang="en"]'
  end
end
