require 'spec_helper'

describe MembersController do
  describe 'routing' do

    it 'routes to #index' do
      get('/members').should route_to('members#index')
    end

    it 'routes to #new' do
      get('/members/new').should route_to('members#new')
    end

    it 'routes to #show' do
      get('/members/1').should route_to('members#show', id: '1')
    end

    it 'routes to #edit' do
      get('/members/1/edit').should route_to('members#edit', id: '1')
    end

    it 'routes to #create' do
      post('/members').should route_to('devise/registrations#create')
    end

    it 'routes to #update' do
      put('/members/1').should route_to('members#update', id: '1')
    end

    it 'routes to #destroy' do
      delete('/members/1').should route_to('members#destroy', id: '1')
    end

  end
end
