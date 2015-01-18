require 'rails_helper'

describe 'Navigation' do
  context 'as a guest' do
    before { visit root_path }

    it 'offers a link to the home page' do
      within 'nav' do
        expect(page).to have_link 'Base'
      end
    end

    it 'offers a link to the about page' do
      within 'nav' do
        expect(page).to have_link 'About'
      end
    end

    it 'offers the possibility to switch languages' do
      within 'nav' do
        expect(page).to have_css '#language_chooser[title="Choose language"]' # Default language is english
        click_link 'Seite auf Deutsch anzeigen'
      end

      within 'nav' do
        expect(page).to have_css '#language_chooser[title="Sprache wählen"]'
        click_link 'Show page in english'
      end

      within 'nav' do
        expect(page).to have_css '#language_chooser[title="Choose language"]'
      end
    end
  end

  context 'as a user' do
    before do
      @user = create :user
      sign_in_as @user

      visit root_path
    end
  end

  context 'as an admin' do
    before do
      @admin = create :admin
      sign_in_as @admin

      visit root_path
    end

    it 'offers a link to the admin area' do
      within 'nav' do
        expect(page).to have_link 'Admin'
      end
    end
  end
end
