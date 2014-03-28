require 'spec_helper'

describe ApplicationController do
  controller(ApplicationController) do
    def index
      render text: 'Hello World'
    end
  end

  context 'user not logged in (guest)' do
    it 'creates a guest user for a first request' do
      expect {
        get :index
      }.to change { User.guests.count }.from(0).to 1

      expect(User.guests.last).to be_guest
    end

    it 'skips confirmation for the created guest user' do
      get :index

      expect(User.guests.last.confirmation_token).to be nil
    end

    it 'finds the guest user for a subsequent request' do
      get :index
      expect {
        get :index
      }.not_to change { User.guests.count }
    end

    it 'creates a new guest user if the previously existing one vanished' do
      get :index
      User.delete_all # The session now has an ID pointing to an inexistent user

      expect {
        get :index
      }.to change { session[:guest_user_id] }.from(1).to 2
    end
  end
end
