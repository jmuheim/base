require 'rails_helper'

describe 'Authentification and authorization' do
  context 'guest accessing a page which requires authentification' do
    it 'displays a "You need to sign in or sign up before continuing" message' do
      @user = create :user

      visit edit_user_path @user

      expect(page).to have_flash('You need to sign in or sign up before continuing.').of_type :alert
    end
  end

  context 'guest accessing a page with insufficient privileges' do
    it 'displays a "You are not authorized to access this page" message on permission denied' do

      visit user_registration_path

      expect(page).to have_flash('You are not authorized to access this page.').of_type :alert
    end
  end
end
