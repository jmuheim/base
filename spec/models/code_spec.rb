require 'rails_helper'

RSpec.describe Code do
  before { @user = create :user }

  # it { should belong_to(:page) }
  it { should validate_presence_of(:creator_id).with_message "can't be blank" }
  it { should validate_presence_of(:title).with_message "can't be blank" }
  it { should validate_presence_of(:thumbnail_url).with_message "can't be blank" }
  it { should validate_presence_of(:identifier).with_message "can't be blank" }
  it { should allow_value('pen-id').for(:identifier) }
  it { should allow_value('p3N-1D').for(:identifier) }
  it { should allow_value('pen-with-hyphen-1D').for(:identifier) }
  it { should_not allow_value('somethingother').for(:identifier) }

  # Uniqueness specs are a bit nasty, see http://stackoverflow.com/questions/27046691/cant-get-uniqueness-validation-test-pass-with-shoulda-matcher
  describe 'uniqueness validations' do
    subject { build :code }

    it { should validate_uniqueness_of(:identifier).scoped_to([:codeable_type, :codeable_id]) }
  end

  it 'has a valid factory' do
    expect(create(:code, creator: @user)).to be_valid
  end

  it 'provides optimistic locking' do
    code = create :code, creator: @user
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
      code = create :code, creator: @user

      expect {
        code.update_attributes! identifier: 'some-identifier'
      }.to change { code.versions.count }.by 1
    end

    it 'versions title' do
      code = create :code, creator: @user

      expect {
        code.update_attributes! title: 'daisy'
      }.to change { code.versions.count }.by 1
    end

    it 'versions html' do
      code = create :code, creator: @user

      expect {
        code.update_attributes! html: 'daisy'
      }.to change { code.versions.count }.by 1
    end

    it 'versions css' do
      code = create :code, creator: @user

      expect {
        code.update_attributes! css: 'daisy'
      }.to change { code.versions.count }.by 1
    end

    it 'versions js' do
      code = create :code, creator: @user

      expect {
        code.update_attributes! js: 'daisy'
      }.to change { code.versions.count }.by 1
    end
  end

  describe '#pen_url' do
    it 'returns the URL to the pen view' do
      expect(create(:code, identifier: 'name-with-hyphen-id', creator: @user).pen_url).to eq 'https://codepen.io/name-with-hyphen/pen/id'
    end
  end

  describe '#debug_url' do
    it 'returns the URL to the debug view' do
      expect(create(:code, identifier: 'name-with-hyphen-id', creator: @user).debug_url).to eq 'https://codepen.io/name-with-hyphen/debug/id'
    end
  end
end