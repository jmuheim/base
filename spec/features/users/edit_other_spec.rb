require 'spec_helper'

describe 'Editing other users' do
  before do
    @user  = create :user,  :donald
    @admin = create :admin, :scrooge
  end

  context 'signed in as admin' do
    before { login_as(@admin) }

    it 'grants permission to edit other user' do
      visit edit_user_path @user

      expect(page.driver.status_code).to eq 200
    end
  end

  # This spec isn't really needed, we ensure authorization through heavy ability specs!
  context 'signed in as user' do
    before { login_as(@user) }

    it 'does not grant permission to edit other user' do
      visit edit_user_path @admin

      expect(page).to have_content '403 - Forbidden'
      expect(page.driver.status_code).to eq 403
    end
  end
end
