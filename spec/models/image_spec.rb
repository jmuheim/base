require 'rails_helper'

RSpec.describe Image, type: :model do
  it { should belong_to(:user) }

  describe 'file upload' do
    it 'should accept images (jpg, gif, png)'
    it 'should scale images (different versions!)'
  end

  # Uniqueness specs are a bit nasty, see http://stackoverflow.com/questions/27046691/cant-get-uniqueness-validation-test-pass-with-shoulda-matcher
  describe 'uniqueness validations' do
    subject { build :image }

    it { should validate_uniqueness_of(:identifier).scoped_to :page_id }
  end
end