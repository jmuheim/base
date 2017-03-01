require 'rails_helper'

RSpec.describe Page do
  it { should validate_presence_of(:title).with_message "can't be blank" }

  it { should have_many(:images).dependent :destroy }

  describe 'nested images attributes' do
    it { should accept_nested_attributes_for(:images) }

    it 'rejects empty images' do
      page = create :page

      expect {
        page.update_attributes! images_attributes: []
      }.not_to change { Image.count }
    end

    it 'ignores lock_version' do
      page = create :page

      expect {
        page.update_attributes! images_attributes: [{lock_version: 123}]
      }.not_to change { Image.count }
    end

    it 'ignores _destroy' do
      page = create :page

      expect {
        page.update_attributes! images_attributes: [{_destroy: 1}]
      }.not_to change { Image.count }
    end

    it 'creates a new image' do
      page = create :page

      expect {
        page.update_attributes! images_attributes: [{identifier: 'my-great-identifier',
                                                     file: File.open(dummy_file_path('image.jpg'))
                                                   }]
      }.to change { Image.count }.by 1

      image = Image.last
      expect(image.identifier).to eq 'my-great-identifier'
      expect(File.basename(image.file.to_s)).to eq 'image.jpg'
    end

    it 'updates an existing image' do
      page = create :page, :with_image
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
      page = create :page, :with_image
      image = page.images.first

      expect {
        page.update_attributes! images_attributes: [{id: image.id,
                                                     _destroy: 1,
                                                   }]
      }.to change { Image.count }.by -1
    end
  end

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

  describe '#collection_tree_without_self_and_descendants' do
    it 'returns the collection without self and descendants' do
      parent        = create :page, title: 'parent'
      page          = create :page, title: 'page',          parent: parent
      child         = create :page, title: 'child',         parent: page
      sibling       = create :page, title: 'sibling',       parent: parent
      sibling_child = create :page, title: 'sibling child', parent: sibling

      expect(page.collection_tree_without_self_and_descendants).to eq [parent, sibling, sibling_child]
    end
  end

  describe '#title_with_details' do
    it 'returns the name with the id' do
      page = create(:page)
      expect(page.title_with_details).to eq "Page test title (##{page.id})"
    end
  end

  describe 'browsing' do
    before do
      @root_1                 = create :page, title: 'Root 1'
      @root_1_child_1         = create :page, title: 'Root 1 child 1',         parent: @root_1
      @root_1_child_2         = create :page, title: 'Root 1 child 2',         parent: @root_1
      @root_1_child_2_child_1 = create :page, title: 'Root 1 child 2 child 1', parent: @root_1_child_2
      @root_2                 = create :page, title: 'Root 2'
      @root_2_child_1         = create :page, title: 'Root 2 child 1',         parent: @root_2
    end

    describe '#previous_page' do
      it 'returns the previous page (or nil if first)' do
        expect(@root_1.previous_page).to eq nil
        expect(@root_1_child_1.previous_page).to eq @root_1
        expect(@root_1_child_2.previous_page).to eq @root_1_child_1
        expect(@root_1_child_2_child_1.previous_page).to eq @root_1_child_2
        expect(@root_2.previous_page).to eq @root_1_child_2_child_1
        expect(@root_2_child_1.previous_page).to eq @root_2
      end
    end

    describe '#next_page' do
      it 'returns the next page (or nil if last)' do
        expect(@root_1.next_page).to eq @root_1_child_1
        expect(@root_1_child_1.next_page).to eq @root_1_child_2
        expect(@root_1_child_2.next_page).to eq @root_1_child_2_child_1
        expect(@root_1_child_2_child_1.next_page).to eq @root_2
        expect(@root_2.next_page).to eq @root_2_child_1
        expect(@root_2_child_1.next_page).to eq nil
      end
    end
  end
end