require 'rails_helper'

describe 'Creating user' do
  before { login_as create :user, :admin }

  it 'creates a user' do
    visit new_user_path

    expect(page).to have_title 'Create User - Base'
    expect(page).to have_active_navigation_items 'Users', 'Create User'
    expect(page).to have_breadcrumbs 'Base', 'Users', 'Create'
    expect(page).to have_headline 'Create User'

    expect(page).to have_css 'h2', text: 'Account information'

    fill_in 'user_name',  with: 'newname'
    fill_in 'user_email', with: 'somemail@example.com'
    fill_in 'user_about', with: 'Some info about me'
    select  'Editor',     from: 'user_role'
    check 'user_disabled'

    expect(page).to have_css 'h2', text: 'Password'

    fill_in 'user_password',              with: 'somegreatpassword'
    fill_in 'user_password_confirmation', with: 'somegreatpassword'

    expect(page).to have_css '#user_name[maxlength="100"]'

    fill_in 'user_avatar', with: base64_image[:data]
    attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Create User'
      expect(page).to have_link 'List of Users'
    end

    # Make sure that shared actions also assign default index filter
    expect(find('.actions a', text: 'List of Users')[:href]).to eq find('#meta_navigation a', text: 'List of Users')[:href]

    click_button 'Create User'

    expect(page).to have_flash 'User was successfully created.'
    expect(User.count).to eq 2

    user = User.last
    expect(user.name).to eq 'newname'
    expect(user.email).to eq 'somemail@example.com'
    expect(user.about).to eq 'Some info about me'
    expect(user.role).to eq 'editor'
    expect(user.disabled).to be_truthy
    expect(File.basename(user.avatar.to_s)).to eq 'avatar.png'
    expect(File.basename(user.curriculum_vitae.to_s)).to eq 'document.txt'
  end

  describe 'avatar upload' do
    # See https://github.com/layerssss/paste.js/issues/39
    it 'allows to paste an image directly into the field', js: true do
      visit new_user_path

      # Make sure that the ClipboardToTextareaPastabilizer loaded successfully. Some better tests would be good, but don't know how. See https://github.com/layerssss/paste.js/issues/39.
      expect(page).to have_css '.user_avatar.paste .fa.fa-image', visible: false
      expect(page).to have_css 'textarea#user_avatar.pastable'
    end

    it 'caches an uploaded avatar during validation errors' do
      visit new_user_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Create User'

      expect(page).to have_flash 'User was successfully created.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'avatar.png'
    end

    pending 'replaces a cached uploaded avatar with a new one after validation errors', js: true do
      visit new_user_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Upload another file
      click_link 'Image preview'
      fill_in 'user_avatar', with: base64_other_image[:data]

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Create User'

      expect(page).to have_flash 'User was successfully created.'
      expect(User.last.avatar.file.size).to eq base64_other_image[:size]
    end

    it 'allows to remove a cached uploaded avatar after validation errors' do
      visit new_user_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Remove curriculum_vitae
      check 'user_remove_avatar'

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Create User'

      expect(page).to have_flash 'User was successfully created.'
      expect(User.last.avatar.to_s).to eq ''
    end
  end

  describe 'curriculum_vitae upload' do
    it 'caches an uploaded curriculum_vitae during validation errors' do
      visit new_user_path

      # Upload a file
      attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Create User'

      expect(page).to have_flash 'User was successfully created.'
      expect(File.basename(User.last.curriculum_vitae.to_s)).to eq 'document.txt'
    end

    it 'replaces a cached uploaded curriculum_vitae with a new one after validation errors' do
      visit new_user_path

      # Upload a file
      attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Upload another file
      attach_file 'user_curriculum_vitae', dummy_file_path('other_document.txt')

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Create User'

      expect(page).to have_flash 'User was successfully created.'
      expect(File.basename(User.last.curriculum_vitae.to_s)).to eq 'other_document.txt'
    end

    it 'allows to remove a cached uploaded curriculum_vitae after validation errors' do
      visit new_user_path

      # Upload a file
      attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Remove curriculum_vitae
      check 'user_remove_curriculum_vitae'

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Create User'

      expect(page).to have_flash 'User was successfully created.'
      expect(User.last.curriculum_vitae.to_s).to eq ''
    end
  end

  describe 'textarea fullscreen feature of "about" textarea', js: true do
    it 'applies the fullscreenizer' do
      visit new_user_path

      expect(page).to have_css '.textarea-fullscreenizer'
    end

    it 'shows the fullscreen toggler on focus' do
      visit new_user_path
      scroll_by(0, 10000) # Otherwise the footer overlaps the element and results in a Capybara::Poltergeist::MouseEventFailed, see http://stackoverflow.com/questions/4424790/cucumber-capybara-scroll-to-bottom-of-page

      within '.user_about' do
        expect(page).not_to have_css '.textarea-fullscreenizer-focus'
        expect(page).not_to have_css '.textarea-fullscreenizer-toggler', text: 'Toggle fullscreen (Esc)'

        focus_element('#user_about')
        save_screenshot # See https://stackoverflow.com/questions/65252772/capybara-selenium-chrome-test-passes-only-when-calling-save-screenshot
        expect(page).to have_css '.textarea-fullscreenizer-focus'
        expect(page).to have_css '.textarea-fullscreenizer-toggler', text: 'Toggle fullscreen (Esc)'

        unfocus_element('#user_about')
        expect(page).not_to have_css '.textarea-fullscreenizer-focus'
        expect(page).not_to have_css '.textarea-fullscreenizer-toggler', text: 'Toggle fullscreen (Esc)'
      end
    end

    it 'shows the fullscreen toggler on hover' do
      visit new_user_path

      within '.user_about' do
        expect(page).not_to have_css '.textarea-fullscreenizer-toggler', text: 'Toggle fullscreen (Esc)'
        find('#user_about').hover
        expect(page).to have_css '.textarea-fullscreenizer-toggler', text: 'Toggle fullscreen (Esc)'
      end
    end

    it 'toggles fullscreen on pressing the fullscreen toggler' do
      visit new_user_path

      within '.user_about' do
        find('#user_about').hover
        expect(page).not_to have_css '.textarea-fullscreenizer-fullscreen'

        find('.textarea-fullscreenizer-toggler').click
        expect(page).to have_css '.textarea-fullscreenizer-fullscreen'
        expect(focused_element_id).to eq 'user_about'

        find('.textarea-fullscreenizer-toggler').click
        expect(page).not_to have_css '.textarea-fullscreenizer-fullscreen'
        expect(focused_element_id).to eq 'user_about'
      end
    end

    # Toggling using esc can't be tested (afaik), see http://stackoverflow.com/questions/35177110/testing-javascript-using-rspec-capybara-how-to-improve-my-spec-for-testing-a-t
  end

  # This must be tested because of the following reason: previously, database fields that were set to NOT NULL were validated using model validations (validates presence: true). Now with several translations, all translated fields must allow NULL, otherwise the app crashes.
  it 'allows to create a user in German' do
    visit new_user_path locale: :de # Default locale (English)

    fill_in 'user_name',                  with: 'newname'
    fill_in 'user_email',                 with: 'somemail@example.com'
    fill_in 'user_about',                 with: 'German about'
    fill_in 'user_password',              with: 'somegreatpassword'
    fill_in 'user_password_confirmation', with: 'somegreatpassword'

    click_button 'Benutzer erstellen'

    expect(page).to have_flash 'Benutzer wurde erfolgreich erstellt.'
  end
end
