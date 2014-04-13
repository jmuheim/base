require 'spec_helper'

describe 'Showing users' do
  before { @user = create :user, :donald }

  it 'displays a user' do
    visit user_path(@user)

    within dom_id_selector(@user) do
      expect(page).to have_content 'donald'
      expect(page).to have_content 'donald@example.com'
    end
  end
end
