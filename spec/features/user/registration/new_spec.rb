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
    fill_in 'user_password',              with: 'somegreatpassword'
    fill_in 'user_password_confirmation', with: 'somegreatpassword'

    click_button 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
    expect(unread_emails_for('newuser@example.com').size).to eq 1
    expect(page).to have_link 'Log out'

    visit_in_email('Confirm my account', 'newuser@example.com')
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
