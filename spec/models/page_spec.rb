require 'rails_helper'

RSpec.describe Page, type: :model do
  it { should validate_presence_of(:title).with_message "can't be blank" }
  it { should validate_presence_of(:navigation_title).with_message "can't be blank" }
  it { should validate_presence_of(:content).with_message "can't be blank" }

  it 'has a valid factory' do
    expect(create(:page)).to be_valid
  end

  it 'provides optimistic locking' do
    page = create :page
    stale_page = Page.find(page.id)

    page.update_attribute :title, 'new-title'

    expect {
      stale_page.update_attribute :title, 'even-newer-title'
    }.to raise_error ActiveRecord::StaleObjectError
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end

    it 'versions title' do
      page = create :page

      expect {
        page.update_attributes! title: 'New title'
      }.to change { page.versions.count }.by 1
    end

    it 'versions navigation_title' do
      page = create :page

      expect {
        page.update_attributes! navigation_title: 'New navigation_title'
      }.to change { page.versions.count }.by 1
    end

    it 'versions content' do
      page = create :page

      expect {
        page.update_attributes! content: 'New content'
      }.to change { page.versions.count }.by 1
    end

    it 'versions notes' do
      page = create :page

      expect {
        page.update_attributes! notes: 'New notes'
      }.to change { page.versions.count }.by 1
    end
  end
end
