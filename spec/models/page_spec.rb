require 'rails_helper'

RSpec.describe Page do
  before { @user = create :user }

  describe 'associations' do
    it { should have_many(:children).dependent :restrict_with_error }
    it { should have_many(:codes).dependent :destroy }
    it { should have_many(:images).dependent :destroy }
    it { should belong_to :creator }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :creator_id }

    # Can't use validate_uniqueness_of matcher because of Mobility, see https://github.com/shioyama/mobility/issues/141
    it 'validates language-specific uniqueness of title (scoped to parent_id)' do
      page = create :page, title:    'English title',
                           title_de: 'Deutscher Titel',
                           creator:  @user

      new_page = build :page, creator: @user

      # Try to set same title (should be rejected)
      new_page.title = page.title
      new_page.valid?
      expect(new_page.errors[:title]).to include 'has already been taken'

      # Try to set different title (should be accepted)
      new_page.title = 'New english title'
      new_page.valid?
      expect(new_page.errors[:title]).to be_empty

      # Try to set same title as in German (should be accepted)
      new_page.title = page.title_de
      new_page.valid?
      expect(new_page.errors[:title]).to be_empty

      # Try to set same title, but with different parent_id (should be accepted)
      new_page.title = page.title
      new_page.parent = page
      new_page.valid?
      expect(new_page.errors[:title]).to be_empty
    end
  end

  describe 'nested images attributes' do
    it { should accept_nested_attributes_for(:images) }

    it 'rejects empty images' do
      page = create :page, creator: @user

      expect {
        page.update! images_attributes: []
      }.not_to change { Image.count }
    end

    it 'ignores lock_version' do
      page = create :page, creator: @user

      expect {
        page.update! images_attributes: [{lock_version: 123}]
      }.not_to change { Image.count }
    end

    it 'ignores _destroy' do
      page = create :page, creator: @user

      expect {
        page.update! images_attributes: [{_destroy: 1}]
      }.not_to change { Image.count }
    end

    it 'creates a new image' do
      page = create :page, creator: @user

      expect {
        page.update! images_attributes: [{identifier: 'my-great-identifier',
                                                     file: File.open(dummy_file_path('image.jpg')),
                                                     creator: @user
                                                   }]
      }.to change { Image.count }.by 1

      image = Image.last
      expect(image.identifier).to eq 'my-great-identifier'
      expect(File.basename(image.file.to_s)).to eq 'image.jpg'
    end

    it 'updates an existing image' do
      page = create :page, creator: @user, images: [create(:image, creator: @user)]
      image = page.images.first

      expect {
        page.update! images_attributes: [{id: image.id,
                                                     identifier: 'some-new-identifier',
                                                     file: File.open(dummy_file_path('other_image.jpg'))
                                                   }]
      }.to change { image.reload.identifier }.to('some-new-identifier')
      .and change { File.basename(image.reload.file.to_s) }.to('other_image.jpg')
    end

    it 'removes an existing image' do
      page = create :page, creator: @user, images: [create(:image, creator: @user)]
      image = page.images.first

      expect {
        page.update! images_attributes: [{id: image.id,
                                                     _destroy: 1,
                                                   }]
      }.to change { Image.count }.by -1
    end
  end

  it 'provides optimistic locking' do
    page = create :page, creator: @user
    stale_page = Page.find(page.id)

    page.update_attribute :title, 'new-title'

    expect {
      stale_page.update_attribute :title, 'even-newer-title'
    }.to raise_error ActiveRecord::StaleObjectError
  end

  describe 'versioning', versioning: true do
    describe 'attributes' do
      before { @page = create :page, creator: @user }

      it 'versions title (en/de)' do
        [:en, :de].each do |locale|
          expect {
            @page.update! "title_#{locale}" => 'New title'
          }.to change { @page.versions.count }.by 1
        end
      end

      it 'versions navigation_title (en/de)' do
        [:en, :de].each do |locale|
          expect {
            @page.update! "navigation_title_#{locale}" => 'New navigation_title'
          }.to change { @page.versions.count }.by 1
        end
      end

      it 'versions lead (en/de)' do
        [:en, :de].each do |locale|
          expect {
            @page.update! "lead_#{locale}" => 'New lead'
          }.to change { @page.versions.count }.by 1
        end
      end

      it 'versions content (en/de)' do
        [:en, :de].each do |locale|
          expect {
            @page.update! "content_#{locale}" => 'New content'
          }.to change { @page.versions.count }.by 1
        end
      end

      it 'versions notes' do
        expect {
          @page.update! notes: 'New notes'
        }.to change { @page.versions.count }.by 1
      end
    end
  end

  describe 'translating' do
    before { @page = create :page, creator: @user }

    it 'translates title' do
      expect {
        Mobility.with_locale(:de) { @page.update! title: 'Deutscher Titel' }
        @page.reload
      }.not_to change { @page.title }
      expect(@page.title_de).to eq 'Deutscher Titel'
    end

    it 'translates navigation_title' do
      expect {
        Mobility.with_locale(:de) { @page.update! navigation_title: 'Deutscher Navigations-Titel' }
        @page.reload
      }.not_to change { @page.navigation_title }
      expect(@page.navigation_title_de).to eq 'Deutscher Navigations-Titel'
    end

    it 'translates lead' do
      expect {
        Mobility.with_locale(:de) { @page.update! lead: 'Deutscher Lead' }
        @page.reload
      }.not_to change { @page.lead }
      expect(@page.lead_de).to eq 'Deutscher Lead'
    end

    it 'translates content' do
      expect {
        Mobility.with_locale(:de) { @page.update! content: 'Deutscher Inhalt' }
        @page.reload
      }.not_to change { @page.content }
      expect(@page.content_de).to eq 'Deutscher Inhalt'
    end

    describe 'fallbacks' do
      it 'falls back from german to english' do
        @page.update! title_en: 'English title',
                                 title_de: ''

        Mobility.with_locale(:de) do
          expect(@page.title).to eq 'English title'
        end
      end

      it 'falls back from german to english' do
        @page.update! title_en: '',
                                 title_de: 'Deutscher Name'

        Mobility.with_locale(:en) do
          expect(@page.title).to eq 'Deutscher Name'
        end
      end
    end
  end

  describe '#title_with_details' do
    it 'returns the name with the id' do
      page = create(:page, creator: @user)
      expect(page.title_with_details).to eq "Page test title (##{page.id})"
    end
  end

  describe 'acts as tree' do
    it 'acts as tree' do
      page = create :page, creator: @user
      page.children = [create(:page, title: 'child 1', creator: @user), create(:page, title: 'child 2', creator: @user)]

      expect(page.children.count).to be 2
    end

    it 'sorts by position' do
      root = create :page, creator: @user
      child_1 = create :page, title: 'child 1', creator: @user
      child_2 = create :page, title: 'child 2', creator: @user

      root.children = [child_2, child_1]

      expect(root.children.first).to eq child_2
      expect(root.children.last).to eq child_1
    end
  end

  describe 'acts as list' do
    it 'acts as list' do
      page_1 = create :page, title: 'criterion 1', creator: @user
      page_2 = create :page, title: 'criterion 2', creator: @user

      expect(page_1.position).to be 1
      expect(page_2.position).to be 2
    end

    it 'scopes by parent_id' do
      root = create :page, creator: @user
      child_1 = create :page, title: 'child 1', creator: @user
      child_2 = create :page, title: 'child 2', creator: @user

      root.children = [child_1, child_2]

      expect(root.position).to be 1
      expect(child_1.position).to be 1
      expect(child_2.position).to be 2
    end
  end

  describe '#navigation_title_or_title' do
    it 'returns navigation_title if present' do
      page = create(:page, navigation_title: 'My navigation title', title: 'My title', creator: @user)
      expect(page.navigation_title_or_title).to eq 'My navigation title'
    end

    it 'returns title if navigation_title not present' do
      page = create(:page, navigation_title: nil, title: 'My title', creator: @user)
      expect(page.navigation_title_or_title).to eq 'My title'
    end
  end

  describe '#title_with_details' do
    it 'returns the title and ID' do
      page = create(:page, title: 'My title', creator: @user)
      expect(page.title_with_details).to eq "My title (##{page.id})"
    end
  end

  describe '.human_attribute_name' do
    describe 'not translated attributes' do
      it 'behaves exactly the same as normal' do
        expect(Page.human_attribute_name(:title)).to eq 'Title'
        expect(Page.human_attribute_name(:notes)).to eq 'Notes'
      end
    end

    describe 'translated attributes' do
      it 'in the same locale, it behaves exactly the same as normal' do
        expect(Page.human_attribute_name(:title_en)).to eq 'Title'
      end

      it 'in another locale, it behaves exactly the same as normal' do
        expect(Page.human_attribute_name(:title_de)).to eq 'Title (de)'
      end
    end
  end
end
