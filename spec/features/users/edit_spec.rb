require 'rails_helper'

describe 'Editing user' do
  before { @user = create :user, :donald }

  context 'as a guest' do
    it 'does not grant permission to edit a user' do
      visit edit_user_path(@user)

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
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

      fill_in 'user_name',  with: 'gustav'
      fill_in 'user_email', with: 'new-gustav@example.com'

      attach_file 'user_avatar', dummy_file_path('other_image.jpg')

      expect {
        click_button 'Save'
        @user.reload
      } .to  change { @user.name }.to('gustav')
        .and change { @user.avatar.to_s }
        .and change { @user.unconfirmed_email }.to('new-gustav@example.com')
    end
  end
end
