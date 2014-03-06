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
    before do
      @guest = build :guest
    end

    it 'validates presence of name' do
      pending 'Stubbing does not work, see http://stackoverflow.com/questions/22218538'
      @guest.stub(:set_guest_name) # Disable auto-setting name so validation kicks in
      expect(@guest).to have(1).error_on(:name)
    end

    it 'sets the name to "guest-123"' do
      @guest.valid?
      expect(@guest.name).to eq 'guest-1'

      create :user, guest: true
      @guest.valid?
      expect(@guest.name).to eq 'guest-2'

      create :user
      @guest.valid?
      expect(@guest.name).to eq 'guest-2'
    end

    it 'does not validate uniqueness of name' do
      create :guest, name: 'guest'
      @guest.name = 'guest'
      @guest.valid?

      expect(@guest).to have(0).error_on(:name)
    end

    it 'does not validate presence of email' do
      @guest.email = nil
      @guest.valid?
      expect(@guest).to have(0).errors_on(:email)
    end

    it 'does not validate presence of password' do
      @guest.password = nil
      @guest.valid?
      expect(@guest).to have(0).errors_on(:password)
    end
  end

  describe 'creating a user' do
    before do
      @guest = build :user
      @guest.valid?
    end

    it 'validates presence of name' do
      @guest.name = nil
      expect(@guest).to have(1).error_on(:name)
    end

    it 'validates uniqueness of name' do
      create :user, name: 'josh'
      @guest.name = 'josh'

      expect(@guest).to have(1).error_on(:name)
    end

    it 'validates presence of email' do
      @guest.email = nil
      expect(@guest).to have(1).error_on(:email)
    end

    it 'validates presence of password' do
      @guest.password = nil
      expect(@guest).to have(1).error_on(:password)
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
      it 'excludes guests' do
        user = create :user
        guest = create :guest

        expect(User.all).to eq [user]
      end
    end

    describe '.guests' do
      it 'excludes registered users' do
        user = create :user
        guest = create :guest

        expect(User.guests).to eq [guest]
      end
    end
  end

  describe 'abilities' do
    context 'when is a guest' do
      before  { @guest = create(:guest) }
      subject { Ability.new(@guest) }

      it { should_not be_able_to(:manage,  User.new) }
      it { should     be_able_to(:read,    User.new) }
    end

    context 'when is a registered user' do
      before  { @user = create(:user) }
      subject { Ability.new(@user) }

      it { should_not be_able_to(:manage,  User.new) }
      it { should     be_able_to(:read,    User.new) }
      it { should     be_able_to(:update,  @user) }
      it { should_not be_able_to(:destroy, @user) }
    end

    context 'when is an admin' do
      before  { @admin = create(:admin) }
      subject { Ability.new(@admin) }

      it { should     be_able_to(:manage,  User.new) }
      it { should_not be_able_to(:destroy, @user) }
    end
  end
end
