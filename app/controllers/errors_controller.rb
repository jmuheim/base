class ErrorsController < ApplicationController
  include Gaffe::Errors

  def show
    # The following variables are available:
    @exception # The encountered exception (Eg. `#<ActiveRecord::NotFound …>`)
    @status_code # The status code we should return (Eg. `404`)
    @rescue_response # The "standard" name for the status code (Eg. `:not_found`)
  end
end
