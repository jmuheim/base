require 'spec_helper'

describe 'Signing in' do
  context 'user is not signed up' do
    it 'is not possible to sign in' do
      visit new_user_session_path

      fill_in 'user_login',    with: ''
      fill_in 'user_password', with: ''
      click_button 'Sign in'

      expect(page).to have_content 'Invalid login or password.'
      expect(page).not_to have_link 'Log out'
    end
  end

  context 'user is signed up' do
    before { @user = create :user, :donald }

    it 'is possible to sign in using email' do
      visit new_user_session_path

      fill_in 'user_login',    with: 'donald'
      fill_in 'user_password', with: 's3cur3p@ssw0rd'
      click_button 'Sign in'

      expect(page).to have_content 'Signed in successfully.'
      expect(page).to have_link 'Log out'
    end
  
    it 'is possible to sign in using name' do
      visit new_user_session_path

      fill_in 'user_login',    with: 'donald@example.com'
      fill_in 'user_password', with: 's3cur3p@ssw0rd'
      click_button 'Sign in'

      expect(page).to have_content 'Signed in successfully.'
      expect(page).to have_link 'Log out'
    end

    it 'is not possible to sign in with wrong login' do
      visit new_user_session_path

      fill_in 'user_login',    with: 'unknown'
      fill_in 'user_password', with: 's3cur3p@ssw0rd'
      click_button 'Sign in'

      expect(page).to have_content 'Invalid login or password.'
      expect(page).not_to have_link 'Log out'
    end
  
    it 'is not possible to sign in with wrong password' do
      visit new_user_session_path

      fill_in 'user_login',    with: 'donald'
      fill_in 'user_password', with: 'wrong'
      click_button 'Sign in'

      expect(page).to have_content 'Invalid login or password.'
      expect(page).not_to have_link 'Log out'
    end
  end
end

      