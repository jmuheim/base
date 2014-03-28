module AcceptanceTestsSignInHelper
  include Warden::Test::Helpers
  Warden.test_mode!
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include AcceptanceTestsSignInHelper, type: :feature
end
