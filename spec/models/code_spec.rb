require 'rails_helper'

RSpec.describe Code do
  it { should belong_to(:page) }
  it { should validate_presence_of(:creator_id).with_message "can't be blank" }
  it { should validate_presence_of(:title).with_message "can't be blank" }
  it { should validate_presence_of(:thumbnail_url).with_message "can't be blank" }

  # Uniqueness specs are a bit nasty, see http://stackoverflow.com/questions/27046691/cant-get-uniqueness-validation-test-pass-with-shoulda-matcher
  describe 'uniqueness validations' do
    subject { build :code }

    it { should validate_uniqueness_of(:identifier).scoped_to(:page_id) }
  end

  it 'has a valid factory' do
    expect(create(:code)).to be_valid
  end

  it 'provides optimistic locking' do
    code = create :code
    stale_code = Code.find(code.id)

    code.update_attribute :identifier, 'new-identifier'

    expect {
      stale_code.update_attribute :identifier, 'even-newer-identifier'
    }.to raise_error ActiveRecord::StaleObjectError
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end

    it 'versions identifier' do
      code = create :code

      expect {
        code.update_attributes! identifier: 'daisy'
      }.to change { code.versions.count }.by 1
    end

    it 'versions title' do
      code = create :code

      expect {
        code.update_attributes! title: 'daisy'
      }.to change { code.versions.count }.by 1
    end

    it 'versions html' do
      code = create :code

      expect {
        code.update_attributes! html: 'daisy'
      }.to change { code.versions.count }.by 1
    end

    it 'versions css' do
      code = create :code

      expect {
        code.update_attributes! css: 'daisy'
      }.to change { code.versions.count }.by 1
    end

    it 'versions js' do
      code = create :code

      expect {
        code.update_attributes! js: 'daisy'
      }.to change { code.versions.count }.by 1
    end
  end
end