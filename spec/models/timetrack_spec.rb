require 'rails_helper'

RSpec.describe Timetrack, type: :model do
  it { should validate_presence_of(:name).with_message "can't be blank"}
  it { should validate_presence_of(:work_time).with_message "can't be blank" }
  it { should validate_numericality_of(:work_time).with_message "is not a number" }

  it 'has a valid factory' do
    expect(create(:timetrack)).to be_valid
  end

  describe 'validates numericality of bill time' do
    it 'validates when a work time available' do
      timetrack = create :timetrack, work_time: 2
      expect(timetrack.valid?).to be_truthy
      expect(timetrack.errors).to be_truthy
    end

    it "doesn't validate when no work time available" do
      timetrack = create :timetrack

    end
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
