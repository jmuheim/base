require 'spec_helper'

describe 'Signing up' do
  context 'with valid data' do
    it 'signs up a new user' do
      visit new_user_registration_path

      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'
      click_button 'Sign up'

      expect(page).to have_content 'You have signed up successfully.'
      expect(unread_emails_for('newuser@example.com').size).to eq 1
      expect(page).to have_link 'Log out'
    end
  end
end
