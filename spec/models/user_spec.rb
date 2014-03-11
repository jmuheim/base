# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  guest                  :boolean          default(FALSE)
#

require 'spec_helper'

describe User do
  it { should validate_presence_of(:name).with_message "can't be blank" }
  it { create(:user); should validate_uniqueness_of(:name).case_insensitive }

  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  describe 'creating a guest' do
    it 'validates presence of name' do
      @guest = build :guest, name: nil
      @guest.stub(:set_guest_name) # Disable auto-setting name so validation kicks in
      expect(@guest).to have(1).error_on(:name)
    end

    it 'sets the name to "guest-123"' do
      @guest = build :guest

      expect { @guest.valid? }.to change { @guest.name }.from(nil).to 'guest-1'

      expect {
        create :user, guest: true
        @guest.valid?
      }.to change { @guest.name }.from('guest-1').to 'guest-2'

      expect {
        @guest.valid?
        create :user
      }.not_to change { @guest.name }
    end

    it 'does not validate uniqueness of name' do
      create :guest, name: 'guest'
      @guest = build :guest, name: 'guest'

      expect(@guest).to have(0).error_on(:name)
    end

    it 'does not validate presence of email' do
      @guest = build :guest, email: nil
      expect(@guest).to have(0).errors_on(:email)
    end

    it 'does not validate presence of password' do
      @guest = build :guest, password: nil
      expect(@guest).to have(0).errors_on(:password)
    end
  end

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

  describe '#display_name' do
    describe 'when is a guest' do
      it 'returns "guest"' do
        guest = create :guest
        expect(guest.display_name).to eq 'guest'
      end
    end

    describe 'when is a registered user' do
      it "returns the user's name" do
        user = create :user
        expect(user.display_name).to eq user.name
      end
    end
  end

  describe 'scopes' do
    describe '.default' do
      it 'includes all users' do
        user = create :user
        guest = create :guest

        expect(User.all).to eq [user, guest]
      end
    end

    describe '.registered' do
      it 'only includes registered users' do
        user = create :user
        guest = create :guest

        expect(User.registered).to eq [user]
      end
    end

    describe '.guests' do
      it 'only includes guests' do
        user = create :user
        guest = create :guest

        expect(User.guests).to eq [guest]
      end
    end
  end
end
