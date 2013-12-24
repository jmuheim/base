module AcceptanceTestsSignInHelper
  include Warden::Test::Helpers
  Warden.test_mode!

  def sign_in
    member = FactoryGirl.create :member, password: 'asdfasdf', password_confirmation: 'asdfasdf'
    login_as(member)
    member
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include AcceptanceTestsSignInHelper, type: :feature
end
