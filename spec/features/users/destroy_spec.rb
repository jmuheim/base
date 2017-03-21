require 'rails_helper'

describe 'Deleting user' do
  before { @user = create :user, :donald }

  context 'signed in as user' do
    before { login_as(@user) }

    it 'does not grant permission to delete own user' do
      visit_delete_path_for(@user)

      expect(page).to have_flash('You are not authorized to access this page.').of_type :alert
    end
  end

  context 'signed in as admin' do
    before do
      admin = create :admin, :scrooge
      login_as(admin)
    end

    it 'grants permission to delete other user' do
      expect {
        visit_delete_path_for(@user)
      }.to change { User.count }.by -1

      expect(page).to have_flash 'User was successfully destroyed.'
    end
  end
end
