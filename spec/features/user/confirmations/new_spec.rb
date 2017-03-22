require 'rails_helper'

describe 'Requesting new confirmation' do
  before { @user = create :user, :donald, confirmed_at: nil }

  it 'is possible to request a new confirmation' do
    visit new_user_confirmation_path

    expect(page).to have_title 'Resend confirmation instructions - Base'
    expect(page).to have_active_navigation_items 'Sign up'
    expect(page).to have_breadcrumbs 'Base', 'Sign up', 'Resend confirmation...'
    expect(page).to have_headline 'Resend confirmation instructions'

    within '.frequently_occuring_sign_in_problems' do
      expect(page).to have_css 'h2', text: 'Frequently occurring sign in problems'

      expect(page).to have_link 'Forgot your password?'
      expect(page).to have_link "Didn't receive unlock instructions?"
    end

    within '#new_user' do
      fill_in 'user_email', with: 'donald@example.com'
      click_button 'Resend confirmation instructions'
    end

    expect(page).to have_content 'You will receive an email with instructions for how to confirm your email address in a few minutes.'

    # Two confirmation emails are sent (the first when creating the user, the 2nd one when requesting a new confirmation link). We explicitly have to open the last email, see https://github.com/bmabey/email-spec/issues/163.
    open_last_email_for('donald@example.com')
    visit_in_email('Confirm my account!')

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
