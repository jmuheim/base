require 'rails_helper'

describe 'Navigation' do
  context 'as a guest' do # TODO: This context doesn't really reflect reality. Is it really needed? Maybe a different name (e.g. 'always') would fit better?
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
      expect(page).to have_css '#language_chooser[title="Choose language"]' # Default language is english
      click_link 'Seite auf Deutsch anzeigen'

      expect(page).to have_css '#language_chooser[title="Sprache wählen"]'
      click_link 'Show page in english'

      expect(page).to have_css '#language_chooser[title="Choose language"]'
    end
    
    it 'shows the "Toggle navigation" button on small, medium, and large screens (and collapses it on extra small ones)', js: true do
      within 'nav' do
        screen_width :xs do
          expect(page).to have_button 'Toggle navigation'
        end

        screen_width :sm do
          expect(page).not_to have_button 'Toggle navigation'
        end

        screen_width :md do
          expect(page).not_to have_button 'Toggle navigation'
        end

        screen_width :lg do
          expect(page).not_to have_button 'Toggle navigation'
        end
      end
    end

    it 'reports the status of dropdowns (expanded/collapsed) to non-visual agents', js: true do
      within '#sign_in_panel' do
        expect {
          click_link 'Sign in'
        }.to change { find('.dropdown-toggle')['aria-expanded'].to_b }.from(false).to true
      end
    end

    it 'reports the responsiveness status (expanded/collapsed) to non-visual agents', js: true do
      pending "Bootstrap doesn't support this yet, see https://github.com/twbs/bootstrap/issues/16099"

      within 'nav' do
        screen_width :xs do
          expect {
            click_button 'Toggle navigation'
          }.to change { find('#toggle_navigation')['aria-expanded'].to_b }.from(false).to true
        end
      end
    end

    context 'jump links' do
      # See http://stackoverflow.com/questions/29209518/rspec-and-capybara-how-to-get-the-horizontal-and-vertical-position-of-an-elemen
      it 'visually displays them only on focus', js: true

      it 'moves the focus to the navigation when activating the corresponding link', js: true, only: true do
        pending "Doesn't seem to focus the link, so it's not clickable by Capybara"
        expect(page).not_to have_css '#main:focus'
        page.evaluate_script "$('#jump_to_content > a').focus()"
        click_link 'Jump to content'
        expect(page).to have_css '#main:focus'
      end

      it 'displays the link to the home page only on other pages' do
        expect(page).not_to have_link 'Jump to home page'
        visit page_path('about')
        expect(page).to have_link 'Jump to home page'
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
