require 'spec_helper'

describe Ability do
  context 'when is a guest' do
    before  { @guest = create(:guest) }
    subject { Ability.new(@guest) }

    describe 'managing users' do
      it { should     be_able_to(:create,  User) }

      it { should     be_able_to(:read,    User.new) }
      it { should_not be_able_to(:read,    User.new(guest: true)) }

      it { should_not be_able_to(:update,  User.new) }

      it { should_not be_able_to(:destroy, User.new) }
    end
  end

  context 'when is a registered user' do
    before  { @user = create(:user) }
    subject { Ability.new(@user) }

    describe 'managing users' do
      it { should_not be_able_to(:create,  User) }

      it { should     be_able_to(:read,    User.new) }
      it { should_not be_able_to(:read,    User.new(guest: true)) }

      it { should_not be_able_to(:update,  User.new) }
      it { should     be_able_to(:update,  @user) }

      it { should_not be_able_to(:destroy, User.new) }
      it { should_not be_able_to(:destroy, @user) }
    end
  end

  context 'when is an admin' do
    before  { @admin = create(:admin) }
    subject { Ability.new(@admin) }

    describe 'managing users' do
      it { should     be_able_to(:create,  User) }

      it { should     be_able_to(:read,    User.new) }
      it { should     be_able_to(:read,    User.new(guest: true)) }

      it { should     be_able_to(:update,  User.new) }

      it { should     be_able_to(:destroy, User.new) }
      it { should_not be_able_to(:destroy, @user) }
    end
  end
end
