class HomepageController < ApplicationController
  private

  def check_authorization?
    false
  end

  def authenticate_user?
    false
  end
end