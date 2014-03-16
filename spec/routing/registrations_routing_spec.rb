require 'spec_helper'

describe UsersController do
  describe 'routing' do
    it 'routes to #cancel' do
      get('/user/cancel').should route_to('registrations#cancel')
    end

    it 'routes to #create' do
      post('/user').should route_to('registrations#create')
    end

    it 'routes to #new' do
      get('/user/sign_up').should route_to('registrations#new')
    end

    it 'routes to #edit' do
      get('/user/edit').should route_to('registrations#edit')
    end

    it 'routes to #update' do
      put('/user').should route_to('registrations#update')
    end

    it 'routes to #destroy' do
      delete('/user').should route_to('registrations#destroy')
    end
  end
end
