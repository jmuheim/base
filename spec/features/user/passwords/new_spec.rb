require 'rails_helper'

describe 'Requesting new password' do
  before { @user = create :user, :donald }

  it 'is possible to request a new password' do
    visit new_user_password_path

    expect(page).to have_title 'Forgot your password? - Base'
    expect(page).to have_active_navigation_items 'Sign in'
    expect(page).to have_breadcrumbs 'Base', 'Sign in', 'Forgot your password?'
    expect(page).to have_headline 'Forgot your password?'

    within '.frequently_occuring_sign_in_problems' do
      expect(page).to have_css 'h2', text: 'Frequently occurring sign in problems'

      expect(page).to have_link "Didn't receive confirmation instructions?"
      expect(page).to have_link "Didn't receive unlock instructions?"
    end

    within '#new_user' do
      fill_in 'user_email', with: 'donald@example.com'
      click_button 'Send me reset password instructions'
    end

    expect(page).to have_content 'You will receive an email with instructions on how to reset your password in a few minutes.'

    visit_in_email('Change my password!', 'donald@example.com')

    within '#new_user' do
      fill_in 'user_password',              with: 'thenewpassword'
      fill_in 'user_password_confirmation', with: 'thenewpassword'
      click_button 'Edit password'
    end

    expect(page).to have_content 'Your password has been changed successfully. You are now signed in.'
  end
end
