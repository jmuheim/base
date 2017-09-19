require 'rails_helper'

RSpec.describe Timetrack, type: :model do
  it { should validate_presence_of(:name).with_message "can't be blank"}
  it { should validate_presence_of(:work_time).with_message "can't be blank" }
  it { should validate_numericality_of(:work_time).with_message "is not a number" }
  #it { should validate_presence_of(:bill_time).with_message "is not a number" }
  #it { should validate_numericality_of(:work_time).is_greater_than(0).with_message "must be greater than 0" }
  #it { should validate_numericality_of(:bill_time).is_less_than_or_equal_to(:work_time).with_message "must be less than or equal to"}

  it 'has a valid factory' do
    expect(create(:timetrack)).to be_valid
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end

    it 'versions name' do
      timetrack = create :timetrack

      expect {
        timetrack.update_attributes! name: 'New name'
      }.to change { timetrack.versions.count }.by 1
    end
  end
end
