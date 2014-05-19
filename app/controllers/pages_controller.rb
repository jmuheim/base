class PagesController < ApplicationController
  def show
    render params[:id]
  end
end
