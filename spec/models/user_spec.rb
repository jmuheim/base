require 'rails_helper'

describe User do
  describe 'associations' do
    it { should have_many(:created_codes).dependent :restrict_with_error }
    it { should have_many(:created_images).dependent :restrict_with_error }
    it { should have_many(:created_pages).dependent :restrict_with_error }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to strip_attribute :name }
    it { is_expected.to strip_attribute :about }
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
    describe 'attributes' do
      before { @user = create :user }
      it 'versions name' do
        expect {
          @user.update_attributes! name: 'daisy'
        }.to change { @user.versions.count }.by 1
      end

      it 'versions about (en/de)' do
        [:en, :de].each do |locale|
          expect {
            @user.update_attributes! "about_#{locale}" => 'I like make up'
          }.to change { @user.versions.count }.by 1
        end
      end

      it 'versions role' do
        expect {
          @user.update_attributes! role: 'admin'
        }.to change { @user.versions.count }.by 1
      end
    end
  end

  describe 'translating' do
    before { @user = create :user }

    it 'translates about' do
      expect {
        Mobility.with_locale(:de) { @user.update_attributes! about: 'Deutsches Über' }
        @user.reload
      }.not_to change { @user.about }
      expect(@user.about_de).to eq 'Deutsches Über'
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
