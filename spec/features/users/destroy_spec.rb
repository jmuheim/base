require 'rails_helper'

describe 'Deleting user' do
  before { @user = create :user, :donald }

  context 'signed in as user' do
    before { login_as(@user) }

    it 'does not grant permission to delete own user' do
      visit_delete_path_for(@user)

      expect(page.driver.status_code).to eq 403
    end
  end

  context 'signed in as admin' do
    before do
      admin = create :admin, :scrooge
      login_as(admin)
    end

    it 'grants permission to delete other user' do
      visit_delete_path_for(@user)

      expect(page.driver.status_code).to eq 200
    end
  end
end
