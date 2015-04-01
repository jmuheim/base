require 'rails_helper'

describe 'Editing user' do
  before { @user = create :user, :donald }

  context 'as a guest' do
    it 'does not grant permission to edit a user' do
      visit edit_user_path(@user)

      expect(page.driver.status_code).to eq 403
    end
  end

  context 'signed in as user' do
    before { login_as(@user) }

    it 'grants permission to edit own user' do
      visit edit_user_path(@user)

      expect(page.driver.status_code).to eq 200
    end
  end

  context 'signed in as admin' do
    before do
      admin = create :admin, :scrooge
      login_as(admin)
    end

    it 'grants permission to edit other user' do
      visit edit_user_path(@user)

      fill_in 'user_name', with: 'gustav'

      expect {
        click_button 'Save'
      }.to change { @user.reload.name }.from('donald').to 'gustav'
    end
  end
end
