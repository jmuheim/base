require 'rails_helper'

describe 'Creating user' do
  before { login_as create :admin, :scrooge }

  it 'creates a user' do
    visit new_user_path

    expect(page).to have_active_navigation_items 'Users', 'Create User'
    expect(page).to have_breadcrumbs 'Base', 'Users', 'Create'
    expect(page).to have_headline 'Create User'

    fill_in 'user_name',                  with: 'newname'
    fill_in 'user_email',                 with: 'somemail@example.com'
    fill_in 'user_about',                 with: 'Some info about me'
    fill_in 'user_password',              with: 'somegreatpassword'
    fill_in 'user_password_confirmation', with: 'somegreatpassword'

    attach_file 'user_avatar', dummy_file_path('other_image.jpg')
    click_button 'Create User'

    expect(page).to have_flash 'User was successfully created.'
  end

  # These specs make sure that the rather tricky image upload things are working as expected
  describe 'avatar upload' do
    it 'caches an uploaded avatar during validation errors' do
      visit new_user_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

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
      expect(File.basename(User.last.avatar.to_s)).to eq 'image.jpg'
    end

    it 'replaces a cached uploaded avatar with a new one after validation errors' do
      visit new_user_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Upload another file
      attach_file 'user_avatar', dummy_file_path('other_image.jpg')

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Create User'

      expect(page).to have_flash 'User was successfully created.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'other_image.jpg'
    end

    it 'allows to remove a cached uploaded avatar after validation errors' do
      visit new_user_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Remove avatar
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
end
