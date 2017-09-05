require 'rails_helper'

RSpec.describe Customer do
  it { should validate_presence_of(:name).with_message "can't be blank" }
  it { should validate_uniqueness_of(:name) }

  it 'has a valid factory' do
    expect(create(:customer)).to be_valid
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end

    it 'versions name' do
      customer = create :customer

      expect {
        customer.update_attributes! name: 'New name'
      }.to change { customer.versions.count }.by 1
    end

    it 'versions address' do
      customer = create :customer

      expect {
        customer.update_attributes! address: 'New address'
      }.to change { customer.versions.count }.by 1
    end

    it 'versions description' do
      customer = create :customer

      expect {
        customer.update_attributes! description: 'New des'
      }.to change { customer.versions.count }.by 1
    end
  end
end
