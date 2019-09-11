module ControllerSpecSignInHelper
  def login_as(user)
    sign_in(user)
  end
end

module FeatureSpecSignInHelper
  # See https://github.com/plataformatec/devise/wiki/How-To%3a-Test-with-Capybara
  include Warden::Test::Helpers
  Warden.test_mode!

  # A login_as(user) method is provided already!
end

module ViewSpecSignInHelper
  # See https://stackoverflow.com/questions/5018344/testing-views-that-use-cancan-and-devise-with-rspec/57885197#57885197
  def login_as(user)
    allow(view).to       receive(:signed_in?).and_return   true
    allow(controller).to receive(:current_user).and_return user
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view

  config.include ControllerSpecSignInHelper, type: :controller
  config.include FeatureSpecSignInHelper, type: :feature
  config.include ViewSpecSignInHelper, type: :view
end
