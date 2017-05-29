require 'rails_helper'

describe 'Navigation' do
  before { @user = create(:user) }

  describe 'items' do
    before { create :page, creator: @user }

    context 'as a guest' do
      it 'offers the expected links' do
        visit root_path

        within 'nav' do
          expect(page).to have_link 'Base'

          within '#content_navigation' do
            expect(page).to have_link 'Page test navigation title'
          end

          within '#meta_navigation' do
            expect(page).not_to have_link 'List of Users'
            expect(page).not_to have_link 'Create User'
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
        sign_in_as @user

        visit root_path

        within 'nav' do
          expect(page).to have_link 'Base'

          within '#content_navigation' do
            expect(page).to have_link 'Page test navigation title'
          end

          within '#meta_navigation' do
            expect(page).not_to have_link 'List of Users'
            expect(page).not_to have_link 'Create User'
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
        sign_in_as create :admin, :scrooge

        visit root_path

        within 'nav' do
          expect(page).to have_link 'Base'

          within '#content_navigation' do
            expect(page).to have_link 'Page test navigation title'
          end

          within '#meta_navigation' do
            expect(page).to have_link 'List of Users'
            expect(page).to have_link 'Create User'
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

    expect(page).to have_css '.dropdown-toggle', text: 'Choose language' # Default language is english
    click_link 'Seite auf Deutsch anzeigen'

    expect(page).to have_css '.dropdown-toggle', text: 'Sprache wählen'
    click_link 'Show page in english'

    expect(page).to have_css '.dropdown-toggle', text: 'Choose language'
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

    within '#language_chooser' do
      expect {
        click_link 'Choose language'
      }.to change { find('.dropdown-toggle')['aria-expanded'].to_b }.from(false).to true
    end
  end

  it 'reports the responsiveness status (expanded/collapsed) to non-visual agents', js: true do
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
    sign_in_as create :admin, :scrooge
    visit root_path

    active_menu_group_css  = '.dropdown.active > a.dropdown-toggle'
    active_menu_group_text = 'Users (current menu group)'
    active_menu_item_css   = '.dropdown.active > ul.dropdown-menu > li.active > a'
    active_menu_item_text  = 'List of Users (current menu item)'

    within 'nav' do
      expect(page).not_to have_css  active_menu_group_css
      expect(page).not_to have_text active_menu_group_text

      expect(page).not_to have_css  active_menu_item_css
      expect(page).not_to have_text active_menu_item_text
    end

    click_link 'List of Users'

    within 'nav' do
      expect(page).to have_css active_menu_group_css, text: active_menu_group_text
      expect(page).to have_css active_menu_item_css,  text: active_menu_item_text
    end
  end

  it "only uses root pages as menu groups" do
    parent_page = create :page, creator: @user, title: 'Parent page', navigation_title: nil
    @page       = create :page, creator: @user, title: 'Cool page',   navigation_title: nil, parent: parent_page

    visit root_path

    expect(page).to have_css 'a.dropdown-toggle',                   text: 'Parent page'
    expect(page).to have_css '.dropdown > .dropdown-menu > li > a', text: 'Cool page'
  end

  # A menu group "Users" has a "List of Users" and a "Create User" item, but no "Edit User" item; for the latter, we still want the group to be marked up as active
  it "reports the activity status of menu groups (that don't have an active item) visually and semantically" do
    user = create :admin, :scrooge
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

  it "reports the menu groups and menu items correctly as active" do
    parent_page = create :page, creator: @user, title: 'Parent page', navigation_title: nil
    @page       = create :page, creator: @user, title: 'Cool page',   navigation_title: nil, parent: parent_page

    # First, none of the pages should be reported as active
    visit root_path

    expect(page).to     have_css '.dropdown:not(.active) > a', text: 'Parent page'
    expect(page).not_to have_link 'Parent page (current menu group)'

    expect(page).to     have_css '.dropdown:not(.active) > ul > li a:not(.active)', text: 'Overview'
    expect(page).not_to have_link 'Overview (current menu item)'

    expect(page).to     have_css '.dropdown:not(.active) > ul > li a:not(.active)', text: 'Cool page'
    expect(page).not_to have_link 'Cool page (current menu item)'

    # Now, when visiting the menu group, it should be reported as active, and the overview menu item, too.
    visit page_path(parent_page)

    expect(page).to     have_css '.dropdown.active > a', text: 'Parent page (current menu group)'

    expect(page).to     have_css '.dropdown.active > ul > li.active a', text: 'Overview (current menu item)'

    expect(page).to     have_css '.dropdown.active > ul > li:not(.active)', text: 'Cool page'
    expect(page).not_to have_link 'Cool page (current menu item)'

    # Now, when visiting the menu item, the menu group should be reported as active, and the menu item (but not the overview menu item anymore)
    visit page_path(@page)

    expect(page).to     have_css '.dropdown.active > a', text: 'Parent page (current menu group)'

    expect(page).to     have_css '.dropdown.active > ul > li:not(.active)', text: 'Overview'
    expect(page).not_to have_link 'Overview (current menu item)'

    expect(page).to     have_css '.dropdown.active > ul > li.active a', text: 'Cool page (current menu item)'
  end

  context 'jump links' do
    it 'visually displays them only on focus', js: true do
      visit page_path(create :page, creator: @user)

      ['#jump_to_home_page', '#jump_to_content'].each do |selector|
        expect(page).to have_selector("#{selector}[class='sr-only']")
        focus_element("#{selector}")
        expect(page).not_to have_selector("#{selector}[class='sr-only']")
        unfocus_element("#{selector}")
        expect(page).to have_selector("#{selector}[class='sr-only']")
      end
    end

    it 'jumps to content when clicking jump to content link', js: true do
      visit page_path(create :page, creator: @user)

      focus_element('#jump_to_content')
      click_link 'Jump to content'
      expect(focused_element_id).to eq 'headline_title'
    end

    it 'offers access keys', js: true do
      visit page_path(create :page, creator: @user)

      expect(page).to have_css '#jump_to_home_page[accesskey="0"]'
      expect(page).to have_css '#jump_to_content[accesskey="1"]'
    end

    it 'displays the link to the home page only on other pages' do
      visit root_path
      expect(page).not_to have_link 'Jump to home page'

      visit page_path(create :page, creator: @user)
      expect(page).to have_link 'Jump to home page'
    end
  end
end
