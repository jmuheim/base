require 'rails_helper'

describe 'Requesting new confirmation' do
  before { @user = create :user, :donald, confirmed_at: nil }

  it 'is possible to request a new confirmation' do
    visit new_user_confirmation_path

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
