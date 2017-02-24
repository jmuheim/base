require 'rails_helper'

describe 'Deleting page' do
  before { @page = create :page, :with_image }

  context 'signed in as user' do
    before { login_as(create :user) }

    it 'does not grant permission to delete page' do
      visit_delete_path_for(@page)

      expect(page).to have_status_code 403
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
