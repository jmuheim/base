require 'rails_helper'

describe 'Showing account' do
  context 'as a guest' do
    before { @user = create :user, :donald }

    it 'does not grant permission to show the account' do
      pending "before_filter :authenticate_user! doesn't seem to work, see https://github.com/plataformatec/devise/issues/3349#issuecomment-88604326"

      visit user_registration_path

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
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
