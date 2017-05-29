require 'rails_helper'

RSpec.describe Page do
  before { @creator = create :user }

  it { should validate_presence_of(:title).with_message "can't be blank" }
  it { should validate_presence_of(:creator_id).with_message "can't be blank" }

  it { should have_many(:images).dependent :destroy }

  describe 'nested images attributes' do
    it { should accept_nested_attributes_for(:images) }

    it 'rejects empty images' do
      page = create :page, creator: @creator

      expect {
        page.update_attributes! images_attributes: []
      }.not_to change { Image.count }
    end

    it 'ignores lock_version' do
      page = create :page, creator: @creator

      expect {
        page.update_attributes! images_attributes: [{lock_version: 123}]
      }.not_to change { Image.count }
    end

    it 'ignores _destroy' do
      page = create :page, creator: @creator

      expect {
        page.update_attributes! images_attributes: [{_destroy: 1}]
      }.not_to change { Image.count }
    end

    it 'creates a new image' do
      page = create :page, creator: @creator

      expect {
        page.update_attributes! images_attributes: [{identifier: 'my-great-identifier',
                                                     file: File.open(dummy_file_path('image.jpg')),
                                                     creator: @creator
                                                   }]
      }.to change { Image.count }.by 1

      image = Image.last
      expect(image.identifier).to eq 'my-great-identifier'
      expect(File.basename(image.file.to_s)).to eq 'image.jpg'
    end

    it 'updates an existing image' do
      page = create :page, creator: @creator, images: [create(:image, creator: @creator)]
      image = page.images.first

      expect {
        page.update_attributes! images_attributes: [{id: image.id,
                                                     identifier: 'some-new-identifier',
                                                     file: File.open(dummy_file_path('other_image.jpg'))
                                                   }]
      }.to change { image.reload.identifier }.to('some-new-identifier')
      .and change { File.basename(image.reload.file.to_s) }.to('other_image.jpg')
    end

    it 'removes an existing image' do
      page = create :page, creator: @creator, images: [create(:image, creator: @creator)]
      image = page.images.first

      expect {
        page.update_attributes! images_attributes: [{id: image.id,
                                                     _destroy: 1,
                                                   }]
      }.to change { Image.count }.by -1
    end
  end

  it 'has a valid factory' do
    expect(create(:page, creator: @creator)).to be_valid
  end

  it 'provides optimistic locking' do
    page = create :page, creator: @creator
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
      page = create :page, creator: @creator

      expect {
        page.update_attributes! title: 'New title'
      }.to change { page.versions.count }.by 1
    end

    it 'versions navigation_title' do
      page = create :page, creator: @creator

      expect {
        page.update_attributes! navigation_title: 'New navigation_title'
      }.to change { page.versions.count }.by 1
    end

    it 'versions lead' do
      page = create :page, creator: @creator

      expect {
        page.update_attributes! lead: 'New lead'
      }.to change { page.versions.count }.by 1
    end

    it 'versions content' do
      page = create :page, creator: @creator

      expect {
        page.update_attributes! content: 'New content'
      }.to change { page.versions.count }.by 1
    end

    it 'versions notes' do
      page = create :page, creator: @creator

      expect {
        page.update_attributes! notes: 'New notes'
      }.to change { page.versions.count }.by 1
    end
  end

  describe '#title_with_details' do
    it 'returns the name with the id' do
      page = create(:page, creator: @creator)
      expect(page.title_with_details).to eq "Page test title (##{page.id})"
    end
  end

  describe 'acts as tree' do
    it 'acts as tree' do
      page = create :page, creator: @creator
      page.children = [create(:page, title: 'child 1', creator: @creator), create(:page, title: 'child 2', creator: @creator)]

      expect(page.children.count).to be 2
    end

    it 'sorts by position' do
      root = create :page, creator: @creator
      child_1 = create :page, title: 'child 1', creator: @creator
      child_2 = create :page, title: 'child 2', creator: @creator

      root.children = [child_2, child_1]

      expect(root.children.first).to eq child_2
      expect(root.children.last).to eq child_1
    end
  end

  describe 'acts as list' do
    it 'acts as list' do
      page_1 = create :page, title: 'criterion 1', creator: @creator
      page_2 = create :page, title: 'criterion 2', creator: @creator

      expect(page_1.position).to be 1
      expect(page_2.position).to be 2
    end

    it 'scopes by parent_id' do
      root = create :page, creator: @creator
      child_1 = create :page, title: 'child 1', creator: @creator
      child_2 = create :page, title: 'child 2', creator: @creator

      root.children = [child_1, child_2]

      expect(root.position).to be 1
      expect(child_1.position).to be 1
      expect(child_2.position).to be 2
    end
  end

  describe '#navigation_title_or_title' do
    it 'returns navigation_title if present' do
      page = create(:page, navigation_title: 'My navigation title', title: 'My title', creator: @creator)
      expect(page.navigation_title_or_title).to eq 'My navigation title'
    end

    it 'returns title if navigation_title not present' do
      page = create(:page, navigation_title: nil, title: 'My title', creator: @creator)
      expect(page.navigation_title_or_title).to eq 'My title'
    end
  end

  describe '#title_with_details' do
    it 'returns the title and ID' do
      page = create(:page, title: 'My title', creator: @creator)
      expect(page.title_with_details).to eq "My title (##{page.id})"
    end
  end
end