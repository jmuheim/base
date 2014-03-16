require 'spec_helper'

describe RegistrationsController do
  # Tell devise the correct mapping because we bypass routes
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe "POST 'create'" do
    context 'valid input' do
      it 'creates a guest user and converts it to a registered one' do
        # expect(controller).to receive(:consolidate_registered_user_with_guest)

        expect {
          post 'create', user: { name:                  'josh',
                                 email:                 'josh@example.com',
                                 password:              'joshjosh',
                                 password_confirmation: 'joshjosh'
                               }
        }.to change { User.count }.from(0).to 1

        expect(User.last).not_to be_guest
      end
    end

    context 'invalid input' do
      it 'creates a guest user and does not convert it to a registered one' do
        expect(controller).not_to receive(:consolidate_registered_user_with_guest)

        expect {
          post 'create', user: {}
        }.to change { User.guests.count }.from(0).to 1 # A guest is created first, but the "real" user was invalid and couldn't be created

        expect(User.last).to be_guest
      end
    end
  end
end
