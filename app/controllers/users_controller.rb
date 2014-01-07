class UsersController < ApplicationController
  load_and_authorize_resource
  inherit_resources
  respond_to :html
end
