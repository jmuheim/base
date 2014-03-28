require 'spec_helper'

describe SessionsController do
  describe 'routing' do
    it 'routes to #new' do
      get('/user/sign_up').should route_to('registrations#new')
    end

    it 'routes to #create' do
      post('/user').should route_to('registrations#create')
    end

    it 'routes to #destroy' do
      delete('/user').should route_to('registrations#destroy')
    end
  end
end
