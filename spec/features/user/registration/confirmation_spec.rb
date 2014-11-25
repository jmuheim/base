require 'rails_helper'

describe 'Confirming registration' do
  before { @user = create :user, :donald, confirmed_at: nil }

  it 'confirms the registration' do
    visit_in_email('Confirm my account', 'donald@example.com')

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
