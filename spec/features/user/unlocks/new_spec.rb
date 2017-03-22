require 'rails_helper'

describe 'Requesting new unlock' do
  before { @user = create :user, :donald, confirmed_at: nil }

  it 'is possible to request a new unlock' do
    # First we need to lock the account
    @user.update_attribute :failed_attempts, 20

    visit new_user_session_path

    within '#new_user' do
      fill_in 'user_login',    with: 'donald'
      fill_in 'user_password', with: 'wrong-password'
      click_button 'Sign in'
    end

    expect(page).to have_flash('Your account is locked.').of_type :alert

    # Now we can unlock it
    visit new_user_unlock_path

    expect(page).to have_title 'Resend unlock instructions - Base'
    expect(page).to have_active_navigation_items 'Sign up'
    expect(page).to have_breadcrumbs 'Base', 'Sign up', 'Resend unlock instructions'
    expect(page).to have_headline 'Resend unlock instructions'

    within '.frequently_occuring_sign_in_problems' do
      expect(page).to have_css 'h2', text: 'Frequently occurring sign in problems'

      expect(page).to have_link 'Forgot your password?'
      expect(page).to have_link "Didn't receive confirmation instructions?"
    end

    within '#new_user' do
      fill_in 'user_email', with: 'donald@example.com'
      click_button 'Resend unlock instructions'
    end

    expect(page).to have_flash('You will receive an email with instructions for how to unlock your account in a few minutes.').of_type :notice

    open_last_email_for('donald@example.com')
    visit_in_email('Unlock my account!')

    expect(page).to have_flash('Your account has been unlocked successfully. Please sign in to continue.').of_type :notice
  end
end
