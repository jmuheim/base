require 'rails_helper'

RSpec.describe Timetrack, type: :model do
  it { should validate_presence_of(:name).with_message "can't be blank"}
  it { should validate_presence_of(:work_time).with_message "can't be blank" }

  it 'has a valid factory' do
    expect(create(:timetrack)).to be_valid
  end
end
