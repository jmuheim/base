class PagesController < ApplicationController
  def show
    render params[:view]
  end
end
