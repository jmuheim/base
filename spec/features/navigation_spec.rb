require 'spec_helper'

describe 'Navigation' do
  context 'as a guest' do
    before { visit root_path }

    it 'offers a link to the home page' do
      expect(page).to have_link 'Base'
    end

    it 'offers a link to the about page' do
      expect(page).to have_link 'About'
    end

    it 'offers the possibility to switch languages' do
      within '#language_chooser' do
        expect(page).to have_link 'Choose language' # Default language is english
        click_link 'Seite auf Deutsch anzeigen'
      end

      within '#language_chooser' do
        expect(page).to have_link 'Sprache wählen'
        click_link 'Show page in english'
      end

      within '#language_chooser' do
        expect(page).to have_link 'Choose language'
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
      expect(page).to have_link 'Admin'
    end
  end
end
