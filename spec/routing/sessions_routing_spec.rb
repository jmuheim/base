require 'spec_helper'

describe SessionsController do
  describe 'routing' do
    it 'routes to #new' do
      expect(get('/user/sign_up')).to route_to('registrations#new')
    end

    it 'routes to #create' do
      expect(post('/user')).to route_to('registrations#create')
    end

    it 'routes to #destroy' do
      expect(delete('/user')).to route_to('registrations#destroy')
    end
  end
end
