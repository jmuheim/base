require 'rails_helper'

describe 'Signing up' do
  it 'signs up a new user and lets him confirm his email' do
    visit new_user_registration_path

    expect(page).to have_active_navigation_items 'Sign up'
    expect(page).to have_breadcrumbs 'Base', 'Sign up'
    expect(page).to have_headline 'Sign up'

    attach_file 'user_avatar', dummy_file_path('image.jpg')

    fill_in 'user_name',                  with: 'newuser'
    fill_in 'user_email',                 with: 'newuser@example.com'
    fill_in 'user_about',                 with: 'Some info about me'
    fill_in 'user_password',              with: 'somegreatpassword'
    fill_in 'user_password_confirmation', with: 'somegreatpassword'

    click_button 'Sign up'

    expect(page).to have_flash 'Welcome! You have signed up successfully.'
    expect(unread_emails_for('newuser@example.com').size).to eq 1
    expect(page).to have_link 'Log out'

    visit_in_email('Confirm my account', 'newuser@example.com')
    expect(page).to have_flash 'Your email address has been successfully confirmed.'
  end

  # These specs make sure that the rather tricky image upload things are working as expected
  describe 'avatar upload' do
    it 'caches an uploaded avatar during validation errors' do
      visit new_user_registration_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

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
      expect(File.basename(User.last.avatar.to_s)).to eq 'image.jpg'
    end

    it 'replaces a cached uploaded avatar with a new one after validation errors' do
      visit new_user_registration_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

      # Trigger validation error
      click_button 'Sign up'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Upload another file
      attach_file 'user_avatar', dummy_file_path('other_image.jpg')

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Sign up'

      expect(page).to have_flash 'Welcome! You have signed up successfully.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'other_image.jpg'
    end

    it 'allows to remove a cached uploaded avatar after validation errors' do
      visit new_user_registration_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

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
end
