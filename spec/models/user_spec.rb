require 'rails_helper'

describe User do
  it { should validate_presence_of(:name).with_message "can't be blank" }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to strip_attribute(:name) }
  it { is_expected.to strip_attribute(:about) }

  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  it 'provides optimistic locking' do
    user = create :user
    stale_user = User.find(user.id)

    user.update_attribute :name, 'new-name'

    expect {
      stale_user.update_attribute :name, 'even-newer-name'
    }.to raise_error ActiveRecord::StaleObjectError
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end

    it 'versions name' do
      user = create :user, :donald

      expect {
        user.update_attributes! name: 'daisy'
      }.to change { user.versions.count }.by 1
    end

    it 'versions about' do
      user = create :user, :donald

      expect {
        user.update_attributes! about: 'I like make up'
      }.to change { user.versions.count }.by 1
    end
  end

  # TODO: Why do we have these specs double?
  describe 'creating a user' do
    it 'validates presence of name' do
      @user = build :user, name: nil
      expect(@user).to have(1).error_on(:name)
    end

    it 'validates uniqueness of name' do
      create :user, name: 'josh'
      @user = build :user, name: 'josh'

      expect(@user).to have(1).error_on(:name)
    end

    it 'validates presence of email' do
      @user = build :user, email: nil
      expect(@user).to have(1).error_on(:email)
    end

    it 'validates presence of password' do
      @user = build :user, password: nil
      expect(@user).to have(1).error_on(:password)
    end
  end
end
