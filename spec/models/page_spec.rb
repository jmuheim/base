require 'rails_helper'

RSpec.describe Page, type: :model do
  it { should validate_presence_of(:title).with_message "can't be blank" }
  it { should validate_presence_of(:navigation_title).with_message "can't be blank" }
  it { should validate_presence_of(:content).with_message "can't be blank" }

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

    it 'creates a new finding' do
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

    it 'updates an existing finding' do
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

    it 'removes an existing finding' do
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

  describe '#content_with_referenced_images' do
    before { @page = create(:page, :with_image) }

    it 'replaces image identifiers of block images with absolute web paths' do
      @page.update_attribute :content, "Some text.\n\n[My image](Image test identifier)\n\nSome more text."
      expect(@page.content_with_referenced_images).to eq "Some text.\n\n[My image](/uploads/image/file/1/image.jpg)\n\nSome more text."
    end

    it 'replaces image identifiers of inline images with absolute web paths' do
      @page.update_attribute :content, "This is an [inline image](Image test identifier)!"
      expect(@page.content_with_referenced_images).to eq "This is an [inline image](/uploads/image/file/1/image.jpg)!"
    end

    it 'replaces image identifiers of more than one inline image in a row with absolute web paths' do
      @page.images << create(:image, identifier: 'other',
                                     file:       File.open(dummy_file_path('other_image.jpg')))

      @page.update_attribute :content, "This is [an inline image](Image test identifier), and [another inline image](other)!"
      expect(@page.content_with_referenced_images).to eq "This is [an inline image](/uploads/image/file/1/image.jpg), and [another inline image](/uploads/image/file/2/other_image.jpg)!"
    end
  end
end
