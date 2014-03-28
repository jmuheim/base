require 'spec_helper'

describe SessionsController do
  # Tell devise the correct mapping because we bypass routes
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe "POST 'create'" do
    context 'valid input' do
      it 'creates a guest user, logs in, and removes the guest user' do
        expect(controller).to receive(:remove_guest_user)

        create :user, name: 'josh', password: 'joshjosh', password_confirmation: 'joshjosh'

        expect {
          post 'create', user: { login:    'josh',
                                 password: 'joshjosh'
                               }
        }.not_to change(User.guests, :count)
      end
    end

    context 'invalid input' do
      it 'creates a guest user and rejects logging in' do
        expect(controller).not_to receive(:remove_guest_user)

        create :user, name: 'josh', password: 'joshjosh', password_confirmation: 'joshjosh'

        expect {
          post 'create', user: { login:    'josh',
                                 password: 'wrongpass'
                               }
        }.to change(User.guests, :count).from(0).to 1
      end
    end
  end
end
