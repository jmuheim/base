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

    it 'finds the guest user for a subsequent request' do
      get :index
      expect {
        get :index
      }.not_to change { User.guests.count }
    end

    it 'creates a new guest user if the previously existing one vanished' do
      get :index

      controller.instance_variable_set('@guest_user', nil) # Instance vars seem to persist between multiple requests in controller tests, so we have to reset some stuff here, see http://stackoverflow.com/questions/22118096
      controller.session[:guest_user_id] = 666 # We can't simply destroy the user, as the ActiveRecord relation isn't reloaded, too.

      expect {
        get :index
      }.to change { User.guests.count }.from(1).to 2

      expect(User.last).to be_guest
    end
  end
end
