require 'rails_helper'

RSpec.describe Image, type: :model do
  it { should belong_to(:page) }

  # Uniqueness specs are a bit nasty, see http://stackoverflow.com/questions/27046691/cant-get-uniqueness-validation-test-pass-with-shoulda-matcher
  describe 'uniqueness validations' do
    subject { build :image }

    it { should validate_uniqueness_of(:identifier) }
  end

  it 'has a valid factory' do
    expect(create(:image)).to be_valid
  end

  it 'provides optimistic locking' do
    image = create :image
    stale_image = Image.find(image.id)

    image.update_attribute :identifier, 'new-identifier'

    expect {
      stale_image.update_attribute :identifier, 'even-newer-identifier'
    }.to raise_error ActiveRecord::StaleObjectError
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end

    it 'versions identifier' do
      image = create :image

      expect {
        image.update_attributes! identifier: 'daisy'
      }.to change { image.versions.count }.by 1
    end
  end
end