require 'rails_helper'

RSpec.describe Project do
  it { should validate_presence_of(:name).with_message "can't be blank" }

  it 'has a valid factory' do
    expect(create(:project)).to be_valid
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end

    it 'versions name' do
      project = create :project

      expect {
        project.update_attributes! name: 'New name'
      }.to change { project.versions.count }.by 1
    end
  end
end
