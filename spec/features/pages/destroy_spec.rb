require 'rails_helper'

describe 'Deleting page' do
  before do
    @user = create :user
    @page = create :page, creator: @user, images: [create(:image, creator: @user)]
  end

  context 'signed in as user' do
    before { login_as(@user) }

    it 'does not grant permission to delete page' do
      visit_delete_path_for(@page)

      expect(page).to have_flash('You are not authorized to access this page.').of_type :alert
    end
  end

  context 'signed in as admin' do
    before { login_as(create :admin, :scrooge) }

    it 'grants permission to delete page' do
      expect {
        visit_delete_path_for(@page)
      }.to change { Page.count }.by(-1)
      .and change { Image.count }.by -1

      expect(page).to have_flash 'Page was successfully destroyed.'
    end
  end
end
