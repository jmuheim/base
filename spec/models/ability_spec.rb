# The ability is built upon the "everything disallowed first" principle:
# Nothing is allowed if not explicitly allowed somewhere. This means we have to test every explicit rule.

require 'rails_helper'

describe Ability do
  context 'when is a guest' do
    subject { Ability.new nil }

    describe 'managing pages' do
      it { should_not be_able_to(:create, Page) }

      it { should     be_able_to(:read, Page.new) }

      it { should_not be_able_to(:update, Page.new) }

      it { should_not be_able_to(:destroy, Page.new) }
    end

    describe 'managing roles' do
      it { should_not be_able_to(:create, Role) }

      it { should_not be_able_to(:read, Role.new) }

      it { should_not be_able_to(:update, Role.new) }

      it { should_not be_able_to(:destroy, Role.new) }
    end

    describe 'managing users' do
      it { should be_able_to(:create, User) }

      it { should_not be_able_to(:read, User.new) }

      it { should_not be_able_to(:update, User.new) }

      it { should_not be_able_to(:destroy, User.new) }
    end
  end

  context 'when is a registered user' do
    before  { @user = create(:user) }
    subject { Ability.new(@user) }

    describe 'managing pages' do
      it { should_not be_able_to(:create, Page) }

      it { should     be_able_to(:read, Page.new) }

      it { should_not be_able_to(:update, Page.new) }

      it { should_not be_able_to(:destroy, Page.new) }
    end

    describe 'managing roles' do
      it { should_not be_able_to(:create, Role) }

      it { should_not be_able_to(:read, Role.new) }

      it { should_not be_able_to(:update, Role.new) }

      it { should_not be_able_to(:destroy, Role.new) }
    end

    describe 'managing users' do
      it { should_not be_able_to(:create, User) }

      it { should_not be_able_to(:read, User.new) }

      it { should_not be_able_to(:update, User.new) }
      it { should     be_able_to(:update, @user) }

      it { should_not be_able_to(:destroy, User.new) }
      it { should_not be_able_to(:destroy, @user) }
    end
  end

  context 'when is an admin' do
    before  { @admin = create(:admin) }
    subject { Ability.new(@admin) }

    it { should be_able_to(:access, :rails_admin) }

    describe 'managing pages' do
      it { should be_able_to(:create, Page) }

      it { should be_able_to(:read, Page.new) }

      it { should be_able_to(:update, Page.new) }

      it { should     be_able_to(:destroy, Page.new) }
      it { should_not be_able_to(:destroy, Page.new(system: true)) }
    end

    describe 'managing roles' do
      it { should be_able_to(:create, Role) }

      it { should be_able_to(:read, Role.new) }

      it { should be_able_to(:update, Role.new) }

      it { should be_able_to(:destroy, Role.new) }
    end

    describe 'managing users' do
      it { should be_able_to(:create, User) }

      it { should be_able_to(:read, User.new) }

      it { should be_able_to(:update, User.new) }

      it { should     be_able_to(:destroy, User.new) }
      it { should_not be_able_to(:destroy, @admin) }
    end
  end
end
