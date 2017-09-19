require 'rails_helper'

RSpec.describe Timetrack, type: :model do
  it { should validate_presence_of(:name).with_message "can't be blank"}
  it { should validate_presence_of(:work_time).with_message "can't be blank" }
  it { should validate_presence_of(:bill_time).with_message "can't be blank" }
  pending 'Numericality of work time, incl. greater 0!'
  pending 'Numericality of bill time, incl. greater 0 and less or equal to work time!'

  it 'has a valid factory' do
    expect(create(:timetrack)).to be_valid
  end

  describe 'versioning' do
    pending 'See page specs!'
  end
end
