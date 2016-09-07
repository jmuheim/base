module ControllerSpecSignInHelper
  def sign_in_as(user)
    sign_in(user)
    user
  end
end

RSpec.configure do |config|
  config.include ControllerSpecSignInHelper, type: :controller
end

module FeatureSpecSignInHelper
  # See https://github.com/plataformatec/devise/wiki/How-To%3a-Test-with-Capybara
  include Warden::Test::Helpers
  Warden.test_mode!

  def sign_in_as(user)
    login_as(user)
    user
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include FeatureSpecSignInHelper, type: :feature
end
