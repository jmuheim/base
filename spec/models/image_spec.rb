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
        image.update! identifier: 'daisy'
      }.to change { image.versions.count }.by 1
    end
  end
end
