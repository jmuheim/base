require 'rails_helper'

# TODO: At the time being, we sometimes use load_and_authorize_resource, sometimes :authenticate_user!, and sometimes a combination of both. We maybe want to unify this behaviour?
describe 'Authentification and authorization' do
  context 'guest accessing a page which requires authentification' do
    it 'displays an "You need to sign in or sign up before continuing" message' do
      @user = create :user
      visit edit_user_path @user
      expect(page).to have_flash('You need to sign in or sign up before continuing.').of_type :alert
    end
  end

  context 'accessing a page without sufficient privileges' do
    it 'displays a "You are not authorized to access this page" message on permission denied' do
      visit user_registration_path
      expect(page).to have_flash('You are not authorized to access this page.').of_type :alert
    end
  end
end
