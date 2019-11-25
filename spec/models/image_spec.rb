require 'rails_helper'

RSpec.describe Image do
  before { @user = create :user }

  describe 'associations' do
    it { should belong_to :imageable }
    it { should belong_to :creator }
  end

  describe 'validations' do
    subject { build :image, creator: @user }

    it { should validate_presence_of :creator_id }
    it { should validate_presence_of :identifier }
    it { should validate_uniqueness_of(:identifier).scoped_to [:imageable_type, :imageable_id] }

    # Standard matcher doesn't work for upload fields
    it 'validates presence of file' do
      image = build :image, file: nil, creator: @user
      image.valid?
      expect(image.errors[:file]).to include "can't be blank"
    end
  end

  it 'provides optimistic locking' do
    image = create :image, creator: @user
    stale_image = Image.find(image.id)

    image.update_attribute :identifier, 'new-identifier'

    expect {
      stale_image.update_attribute :identifier, 'even-newer-identifier'
    }.to raise_error ActiveRecord::StaleObjectError
  end

  describe 'versioning', versioning: true do
    it 'versions identifier' do
      image = create :image, creator: @user

      expect {
        image.update_attributes! identifier: 'daisy'
      }.to change { image.versions.count }.by 1
    end

    it 'versions file' do
      image = create :image, creator: @user

      expect {
        image.update_attributes! file: File.open(dummy_file_path('other_image.jpg'))
      }.to change { image.versions.count }.by 1
    end
  end
end
