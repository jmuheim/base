require 'rails_helper'

describe 'Signing in' do
  context 'user is not signed up' do
    it 'is not possible to sign in' do
      visit new_user_session_path

      within '#new_user' do
        fill_in 'user_login',    with: ''
        fill_in 'user_password', with: ''
        click_button 'Sign in'
      end

      expect(page).to have_flash('Invalid login or password.').of_type :alert
      expect(page).not_to have_link 'Log out'
    end
  end

  context 'user is signed up' do
    before { @user = create :user }

    it 'is possible to sign in using email' do
      visit new_user_session_path

      expect(page).to have_title 'Sign in - Base'
      expect(page).to have_active_navigation_items 'Sign in'
      expect(page).to have_breadcrumbs 'Base', 'Sign in'
      expect(page).to have_headline 'Sign in'

      within '.frequently_occuring_sign_in_problems' do
        expect(page).to have_css 'h2', text: 'Frequently occurring sign in problems'

        expect(page).to have_link 'Forgot your password?'
        expect(page).to have_link "Didn't receive confirmation instructions?"
        expect(page).to have_link "Didn't receive unlock instructions?"
      end

      within '#new_user' do
        fill_in 'user_login',    with: 'User test name'
        fill_in 'user_password', with: 's3cur3p@ssw0rd'
        click_button 'Sign in'
      end

      expect(page).to have_flash('Signed in successfully.').of_type :notice
      expect(page).to have_link 'Log out'
    end

    it 'is possible to sign in using name' do
      visit new_user_session_path

      within '#new_user' do
        fill_in 'user_login',    with: 'user@example.com'
        fill_in 'user_password', with: 's3cur3p@ssw0rd'
        click_button 'Sign in'
      end

      expect(page).to have_flash('Notice: Signed in successfully.').of_type :notice
      expect(page).to have_link 'Log out'
    end

    it 'is not possible to sign in with wrong login' do
      visit new_user_session_path

      within '#new_user' do
        fill_in 'user_login',    with: 'unknown'
        fill_in 'user_password', with: 's3cur3p@ssw0rd'
        click_button 'Sign in'
      end

      expect(page).to have_flash('Invalid login or password.').of_type :alert
      expect(page).not_to have_link 'Log out'
    end

    it 'is not possible to sign in with wrong password' do
      visit new_user_session_path

      within '#new_user' do
        fill_in 'user_login',    with: 'donald'
        fill_in 'user_password', with: 'wrong'
        click_button 'Sign in'
      end

      expect(page).to have_flash('Invalid login or password.').of_type :alert
      expect(page).not_to have_link 'Log out'
    end

    it 'is not possible to sign in when user is disabled' do
      @user.disabled = true
      @user.save!

      visit new_user_session_path

      within '#new_user' do
        fill_in 'user_login',    with: 'User test name'
        fill_in 'user_password', with: 's3cur3p@ssw0rd'
        click_button 'Sign in'
      end

      expect(page).to have_flash('Your account is not activated yet (or has been disabled).').of_type :alert
      expect(page).not_to have_link 'Log out'
    end
  end
end
