require 'rails_helper'

describe 'Signing up' do
  it 'signs up a new user and lets him confirm his email' do
    visit new_user_registration_path

    expect(page).to have_title 'Sign up - Base'
    expect(page).to have_active_navigation_items 'Sign up'
    expect(page).to have_breadcrumbs 'Base', 'Sign up'
    expect(page).to have_headline 'Sign up'

    attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')
    fill_in 'user_avatar', with: base64_image[:data]

    fill_in 'user_name',                  with: 'newuser'
    fill_in 'user_email',                 with: 'newuser@example.com'
    fill_in 'user_about',                 with: 'Some info about me'
    fill_in 'user_password',              with: 'somegreatpassword'
    fill_in 'user_password_confirmation', with: 'somegreatpassword'

    within '.frequently_occuring_sign_in_problems' do
      expect(page).to have_css 'h2', text: 'Frequently occurring sign in problems'

      expect(page).to have_link 'Forgot your password?'
      expect(page).to have_link "Didn't receive confirmation instructions?"
      expect(page).to have_link "Didn't receive unlock instructions?"
    end

    click_button 'Sign up'

    expect(page).to have_flash 'Welcome! You have signed up successfully.'

    expect(unread_emails_for('newuser@example.com').size).to eq 1
    expect(page).to have_link 'Log out'

    visit_in_email('Confirm my account', 'newuser@example.com')
    expect(page).to have_flash 'Your email address has been successfully confirmed.'
  end

  describe 'avatar upload' do
    it 'caches an uploaded avatar during validation errors' do
      visit new_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Sign up'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Sign up'

      expect(page).to have_flash 'Welcome! You have signed up successfully.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'avatar.png'
    end

    it 'replaces a cached uploaded avatar with a new one after validation errors', js: true do
      visit new_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Sign up'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Upload another file
      scroll_by(0, 10000) # Otherwise the footer overlaps the element and results in a Capybara::Poltergeist::MouseEventFailed, see http://stackoverflow.com/questions/4424790/cucumber-capybara-scroll-to-bottom-of-page
      click_link 'Click to paste another Profile picture image'
      fill_in 'user_avatar',  with: base64_other_image[:data]

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Sign up'

      expect(page).to have_flash 'Welcome! You have signed up successfully.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'avatar.png'
    end

    it 'allows to remove a cached uploaded avatar after validation errors' do
      visit new_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Sign up'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Remove avatar
      check 'user_remove_avatar'

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Sign up'

      expect(page).to have_flash 'Welcome! You have signed up successfully.'
      expect(User.last.avatar.to_s).to eq ''
    end
  end

  describe 'curriculum_vitae upload' do
    it 'caches an uploaded curriculum_vitae during validation errors' do
      visit new_user_registration_path

      # Upload a file
      attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')

      # Trigger validation error
      click_button 'Sign up'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Sign up'

      expect(page).to have_flash 'Welcome! You have signed up successfully.'
      expect(File.basename(User.last.curriculum_vitae.to_s)).to eq 'document.txt'
    end

    it 'replaces a cached uploaded curriculum_vitae with a new one after validation errors' do
      visit new_user_registration_path

      # Upload a file
      attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')

      # Trigger validation error
      click_button 'Sign up'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Upload another file
      attach_file 'user_curriculum_vitae', dummy_file_path('other_document.txt')

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Sign up'

      expect(page).to have_flash 'Welcome! You have signed up successfully.'
      expect(File.basename(User.last.curriculum_vitae.to_s)).to eq 'other_document.txt'
    end

    it 'allows to remove a cached uploaded curriculum_vitae after validation errors' do
      visit new_user_registration_path

      # Upload a file
      attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')

      # Trigger validation error
      click_button 'Sign up'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Remove curriculum_vitae
      check 'user_remove_curriculum_vitae'

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Sign up'

      expect(page).to have_flash 'Welcome! You have signed up successfully.'
      expect(User.last.curriculum_vitae.to_s).to eq ''
    end
  end
end
