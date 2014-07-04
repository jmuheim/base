require 'spec_helper'

describe UsersController do
  describe 'routing' do
    it 'routes to #cancel' do
      expect(get('/user/cancel')).to route_to('registrations#cancel')
    end

    it 'routes to #create' do
      expect(post('/user')).to route_to('registrations#create')
    end

    it 'routes to #new' do
      expect(get('/user/sign_up')).to route_to('registrations#new')
    end

    it 'routes to #edit' do
      expect(get('/user/edit')).to route_to('registrations#edit')
    end

    it 'routes to #update' do
      expect(put('/user')).to route_to('registrations#update')
    end

    it 'routes to #destroy' do
      expect(delete('/user')).to route_to('registrations#destroy')
    end
  end
end
