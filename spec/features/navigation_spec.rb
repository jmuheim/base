require 'rails_helper'

describe 'Navigation' do
  context 'as a guest' do # TODO: This context doesn't really reflect reality. Is it really needed? Maybe a different name (e.g. 'always') would fit better?
    it 'offers a link to the home page' do
      visit root_path

      within 'nav' do
        expect(page).to have_link 'Base'
      end
    end

    it 'offers a link to the about page' do
      visit root_path

      within 'nav' do
        expect(page).to have_link 'About'
      end
    end

    it 'offers the possibility to switch languages' do
      visit root_path

      expect(page).to have_css '#language_chooser .dropdown-toggle', text: 'Choose language' # Default language is english
      click_link 'Seite auf Deutsch anzeigen'

      expect(page).to have_css '#language_chooser .dropdown-toggle', text: 'Sprache wählen'
      click_link 'Show page in english'

      expect(page).to have_css '#language_chooser .dropdown-toggle', text: 'Choose language'
    end
    
    it 'shows the "Toggle navigation" button on small, medium, and large screens (and collapses it on extra small ones)', js: true do
      visit root_path

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
      visit root_path

      within '#sign_in_panel' do
        expect {
          click_link 'Sign in'
        }.to change { find('.dropdown-toggle')['aria-expanded'].to_b }.from(false).to true
      end
    end

    it 'reports the responsiveness status (expanded/collapsed) to non-visual agents', js: true do
      pending "Bootstrap doesn't support this yet, see https://github.com/twbs/bootstrap/issues/16099"

      visit root_path

      within 'nav' do
        screen_width :xs do
          expect {
            click_button 'Toggle navigation'
          }.to change { find('#toggle_navigation')['aria-expanded'].to_b }.from(false).to true
        end
      end
    end

    it 'reports the activity status ("current menu group" or "current menu item") of menu groups and items' do
      visit root_path

      within 'nav' do
        expect(page).not_to have_text 'Users (current menu group)'
        expect(page).not_to have_text 'List Users (current menu item)'
      end

      click_link 'List Users'

      within 'nav' do
        expect(page).to have_text 'Users (current menu group)'
        expect(page).to have_text 'List Users (current menu item)'
      end
    end

    context 'jump links' do
      # See http://stackoverflow.com/questions/29209518/rspec-and-capybara-how-to-get-the-horizontal-and-vertical-position-of-an-elemen
      it 'visually displays them only on focus', js: true

      it 'offers access keys', js: true do
        visit page_path('about')

        expect(page).to have_css '#jump_to_home_page a[accesskey="0"]'
        expect(page).to have_css '#jump_to_navigation a[accesskey="1"]'
        expect(page).to have_css '#jump_to_content a[accesskey="2"]'
      end

      it 'exists an HTML ID for every same-page jump link' do
        visit page_path('about')

        expect(page).to have_css '#jump_to_navigation a[href="#navigation"]'
        expect(page).to have_css '#navigation'

        expect(page).to have_css '#jump_to_content a[href="#main"]'
        expect(page).to have_css '#main'
      end

      it 'displays the link to the home page only on other pages' do
        visit root_path
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

      visit destroy_user_session_path

      within 'nav' do
        expect(page).not_to have_link 'Admin'
      end
    end

    it 'offers a link to the create user page' do
      within 'nav' do
        expect(page).to have_link 'Create User'
      end

      visit destroy_user_session_path

      within 'nav' do
        expect(page).not_to have_link 'Create User'
      end
    end
  end
end
