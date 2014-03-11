require 'spec_helper'

describe RegistrationsController do
  # Tell devise the correct mapping because we bypass routes
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe "POST 'create'" do
    context 'valid input' do
      it 'creates a user and deletes the guest user' do
        expect {
          post 'create', user: { name:                  'josh',
                                 email:                 'josh@example.com',
                                 password:              'joshjosh',
                                 password_confirmation: 'joshjosh'
                               }
        }.to change { User.count }.from(0).to 1 # A guest is created first, then the "real" user, then the guest is deleted.

        expect(User.last).not_to be_guest
      end

      it "assigns the guest's preferrably keepable data to the new user" do
        # Nothing here yet
      end
    end

    context 'invalid input' do
      it 'does not create a user and does not delete the guest user' do
        expect {
          post 'create', user: {}
        }.to change { User.guests.count }.from(0).to 1 # A guest is created first, but the "real" user was invalid and couldn't be created

        expect(User.last).to be_guest
      end
    end
  end
end
