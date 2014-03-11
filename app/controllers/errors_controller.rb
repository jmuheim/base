class ErrorsController < ApplicationController
  include Gaffe::Errors
  layout 'application'

  def show
    render "errors/#{@rescue_response}", status: @status_code
  end
end