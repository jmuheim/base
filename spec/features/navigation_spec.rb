require 'rails_helper'

describe 'Navigation' do
  describe 'items' do
    context 'as a guest' do
      it 'offers the expected links' do
        visit root_path

        within 'nav' do
          expect(page).to have_link 'Base'

          within '#content_navigation' do
            expect(page).to     have_link 'List Users'
            expect(page).not_to have_link 'Create User'

            expect(page).to have_link 'About'
          end

          within '#meta_navigation' do
            expect(page).not_to have_link 'Show account'
            expect(page).not_to have_link 'Edit account'
            expect(page).not_to have_link 'Log out'
            expect(page).not_to have_link 'Admin'
          end
        end
      end
    end

    context 'as a user' do
      it 'offers the expected links' do
        sign_in_as create :user

        visit root_path

        within 'nav' do
          expect(page).to have_link 'Base'

          within '#content_navigation' do
            expect(page).to     have_link 'List Users'
            expect(page).not_to have_link 'Create User'

            expect(page).to have_link 'About'
          end

          within '#meta_navigation' do
            expect(page).to     have_link 'Show account'
            expect(page).to     have_link 'Edit account'
            expect(page).to     have_link 'Log out'
            expect(page).not_to have_link 'Admin'
          end
        end
      end
    end

    context 'as an admin' do
      it 'offers the expected links' do
        sign_in_as create :admin

        visit root_path

        within 'nav' do
          expect(page).to have_link 'Base'

          within '#content_navigation' do
            expect(page).to have_link 'List Users'
            expect(page).to have_link 'Create User'

            expect(page).to have_link 'About'
          end

          within '#meta_navigation' do
            expect(page).to have_link 'Show account'
            expect(page).to have_link 'Edit account'
            expect(page).to have_link 'Log out'
            expect(page).to have_link 'Admin'
          end
        end
      end
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
  
  it 'shows the "Menu" button on small, medium, and large screens (and collapses it on extra small ones)', js: true do
    visit root_path

    within 'nav' do
      screen_width :xs do
        expect(page).to have_button 'Menu'
      end

      screen_width :sm do
        expect(page).not_to have_button 'Menu'
      end

      screen_width :md do
        expect(page).not_to have_button 'Menu'
      end

      screen_width :lg do
        expect(page).not_to have_button 'Menu'
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
          click_button 'Menu'
        }.to change { find('#toggle_navigation')['aria-expanded'].to_b }.from(false).to true
      end
    end
  end

  it 'reports the activity status of menu groups and items visually and aurally' do
    visit root_path

    active_menu_group_css  = '.dropdown.active > a.dropdown-toggle'
    active_menu_group_text = 'Users (current menu group)'
    active_menu_item_css   = '.dropdown.active > ul.dropdown-menu > li.active > a'
    active_menu_item_text  = 'List Users (current menu item)'

    within 'nav' do
      expect(page).not_to have_css  active_menu_group_css
      expect(page).not_to have_text active_menu_group_text

      expect(page).not_to have_css  active_menu_item_css
      expect(page).not_to have_text active_menu_item_text
    end

    click_link 'List Users'

    within 'nav' do
      expect(page).to have_css active_menu_group_css, text: active_menu_group_text
      expect(page).to have_css active_menu_item_css,  text: active_menu_item_text
    end
  end

  # A menu group "Users" has a "List users" and a "Create User" item, but no "Edit User" item; for the latter, we still want the group to be marked up as active
  it "reports the activity status of menu groups (that don't have an active item) visually and aurally" do
    user = create :admin
    login_as user

    visit root_path

    active_menu_group_css  = '.dropdown.active > a.dropdown-toggle'
    active_menu_group_text = 'Users (current menu group)'

    within 'nav' do
      expect(page).not_to have_css  active_menu_group_css
      expect(page).not_to have_text active_menu_group_text
    end

    visit edit_user_path(user)

    within 'nav' do
      expect(page).to have_css active_menu_group_css, text: active_menu_group_text
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
