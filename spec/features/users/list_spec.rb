require 'spec_helper'

describe 'Listing users' do
  before { @user = create :user, :donald }

  it 'displays users' do
    visit users_path
    within dom_id_selector(@user) do
      expect(page).to have_content 'donald'
      expect(page).to have_content 'donald@example.com'
      expect(page).to have_link 'Show'
    end
  end
end