require 'rails_helper'

describe 'Showing account' do
  context 'as a guest' do
    before { @user = create :user, :donald }

    it 'does not grant permission to show the account' do
      visit user_registration_path

      expect(page).to have_status_code 403
    end
  end

  context 'signed in as user' do
    before do
      @user = create :user, :donald, :with_avatar
      login_as(@user)
      visit user_registration_path
    end

    it 'displays the account' do
      within dom_id_selector(@user) do
        expect(page).to have_content 'donald'
        expect(page).to have_content 'donald@example.com'
        expect(page).to have_css 'img[alt="donald"]'
        expect(page).to have_link 'Edit'
      end
    end
  end
end
