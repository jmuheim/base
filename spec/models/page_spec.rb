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

    describe 'attributes' do
      before { @page = create :page, creator: @creator }

      it 'versions title' do
        expect {
          @page.update_attributes! title: 'New title'
        }.to change { @page.versions.count }.by 1
      end

      it 'versions navigation_title' do
        expect {
          @page.update_attributes! navigation_title: 'New navigation_title'
        }.to change { @page.versions.count }.by 1
      end

      it 'versions lead' do
        expect {
          @page.update_attributes! lead: 'New lead'
        }.to change { @page.versions.count }.by 1
      end

      it 'versions content' do
        expect {
          @page.update_attributes! content: 'New content'
        }.to change { @page.versions.count }.by 1
      end

      it 'versions notes' do
        expect {
          @page.update_attributes! notes: 'New notes'
        }.to change { @page.versions.count }.by 1
      end
    end
  end

  describe 'translating' do
    before { @page = create :page, creator: @creator }

    it 'translates title' do
      expect {
        Mobility.with_locale(:de) { @page.update_attributes! title: 'Deutscher Titel' }
        @page.reload
      }.not_to change { @page.title }
      expect(@page.title_de).to eq 'Deutscher Titel'
    end

    it 'translates navigation_title' do
      expect {
        Mobility.with_locale(:de) { @page.update_attributes! navigation_title: 'Deutscher Navigations-Titel' }
        @page.reload
      }.not_to change { @page.navigation_title }
      expect(@page.navigation_title_de).to eq 'Deutscher Navigations-Titel'
    end

    it 'translates lead' do
      expect {
        Mobility.with_locale(:de) { @page.update_attributes! lead: 'Deutscher Lead' }
        @page.reload
      }.not_to change { @page.lead }
      expect(@page.lead_de).to eq 'Deutscher Lead'
    end

    it 'translates content' do
      expect {
        Mobility.with_locale(:de) { @page.update_attributes! content: 'Deutscher Inhalt' }
        @page.reload
      }.not_to change { @page.content }
      expect(@page.content_de).to eq 'Deutscher Inhalt'
    end

    describe 'fallbacks' do
      it 'falls back from german to english' do
        @page.update_attributes! title_en: 'English title',
                                 title_de: ''

        Mobility.with_locale(:de) do
          expect(@page.title).to eq 'English title'
        end
      end

      it 'falls back from german to english' do
        @page.update_attributes! title_en: '',
                                 title_de: 'Deutscher Name'

        Mobility.with_locale(:en) do
          expect(@page.title).to eq 'Deutscher Name'
        end
      end
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

  describe '.human_attribute_name' do
    describe 'not translated attributes' do
      it 'behaves exactly the same as normal' do
        expect(Page.human_attribute_name(:title)).to eq 'Title'
        expect(Page.human_attribute_name(:notes)).to eq 'Notes'
      end
    end

    describe 'translated attributes' do
      it 'in the same language, it behaves exactly the same as normal' do
        expect(Page.human_attribute_name(:title_en)).to eq 'Title'
      end

      it 'in another language, it behaves exactly the same as normal' do
        expect(Page.human_attribute_name(:title_de)).to eq 'Title (de)'
      end
    end
  end
end