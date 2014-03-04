### UTILITY METHODS ###

def create_visitor
  @visitor ||= { username: 'Testy McUserton',
                 email: 'example@example.com',
                 password: 'changeme',
                 password_confirmation: 'changeme'
               }
end

def find_user
  @user ||= User.where(email: @visitor[:email]).first
end

def create_unconfirmed_user
  create_visitor
  sign_up
  visit '/users/sign_out'
end

def create_user
  create_visitor
  @user = FactoryGirl.create(:user, @visitor)
end

def sign_up
  visit '/users/sign_up'
  fill_in 'user_username', with: @visitor[:username]
  fill_in 'user_email', with: @visitor[:email]
  fill_in 'user_password', with: @visitor[:password]
  fill_in 'user_password_confirmation', with: @visitor[:password_confirmation]
  click_button 'Sign up'
  find_user
end

def sign_in_using_email
  visit '/users/sign_in'
  fill_in 'user_login', with: @visitor[:email]
  fill_in 'user_password', with: @visitor[:password]
  click_button 'Sign in'
end

def sign_in_using_username
  visit '/users/sign_in'
  fill_in 'user_login', with: @visitor[:username]
  fill_in 'user_password', with: @visitor[:password]
  click_button 'Sign in'
end

module UserSteps
  ### GIVEN ###
  step 'I am not logged in' do
    visit '/users/sign_out'
  end

  step 'I am logged in' do
    create_visitor
    @user = sign_in!
    visit root_path
  end

  step 'I exist as a user' do
    create_user
  end

  step 'I do not exist as a user' do
    create_visitor
  end

  step 'I exist as an unconfirmed user' do
    create_unconfirmed_user
  end

  ### WHEN ###
  step 'I sign in with valid username and password' do
    create_visitor
    sign_in_using_username
  end

  step 'I sign in with valid email and password' do
    create_visitor
    sign_in_using_email
  end

  step 'I sign out' do
    visit '/users/sign_out'
  end

  step 'I sign up with valid user data' do
    create_visitor
    sign_up
  end

  step 'I sign up with an invalid email' do
    create_visitor
    @visitor = @visitor.merge(email: 'notanemail')
    sign_up
  end

  step 'I sign up without a password confirmation' do
    create_visitor
    @visitor = @visitor.merge(password_confirmation: '')
    sign_up
  end

  step 'I sign up without a password' do
    create_visitor
    @visitor = @visitor.merge(password: '')
    sign_up
  end

  step 'I sign up with a mismatched password confirmation' do
    create_visitor
    @visitor = @visitor.merge(password_confirmation: 'changeme123')
    sign_up
  end

  step 'I return to the site' do
    visit '/'
  end

  step 'I sign in with a wrong email' do
    @visitor = @visitor.merge(email: 'wrong@example.com')
    sign_in_using_email
  end

  step 'I sign in with a wrong password' do
    @visitor = @visitor.merge(password: 'wrongpass')
    sign_in_using_username
  end

  step 'I edit my account details' do
    click_link 'Edit account'
    fill_in 'user_username', with: 'newname'
    fill_in 'user_current_password', with: @visitor[:password]
    click_button 'Update'
  end

  step 'I look at the list of users' do
    visit users_path
  end

  step 'I open the confirmation link' do
    expect(ActionMailer::Base.deliveries.count).to eq 1
    email_body = Nokogiri::HTML.parse ActionMailer::Base.deliveries.first.body.raw_source

    expect(email_body).to have_link 'Confirm my account'
    confirmation_url = email_body.at("a[text()='Confirm my account']")[:href]

    visit confirmation_url
  end

  ### THEN ###
  step 'I should be signed in' do
    expect(page).to have_link 'Log out'
    expect(page).not_to have_link 'Login'
    expect(page).not_to have_link 'Register'
  end

  step 'I should be signed out' do
    expect(page).not_to have_link 'Login'
    expect(page).not_to have_link 'Register'
    expect(page).not_to have_link 'Log out'
  end

  step 'I see an unconfirmed account message' do
    expect(page).to have_content 'You have to confirm your account before continuing.'
  end

  step 'I see a successful sign in message' do
    expect(page).to have_content 'Signed in successfully.'
  end

  step 'I should see a welcome message' do
    expect(page).to have_content 'You have signed up successfully.'
  end

  step 'I should see a successful confirmed message' do
    expect(page).to have_content 'Your account was successfully confirmed.'
  end

  step 'I should see an invalid email message' do
    expect(page).to have_content 'Email is invalid'
  end

  step 'I should see a missing password message' do
    expect(page).to have_content "Password can't be blank"
  end

  step 'I should see a missing password confirmation message' do
    expect(page).to have_content "Password confirmation doesn't match"
  end

  step 'I should see a mismatched password message' do
    expect(page).to have_content "Password confirmation doesn't match"
  end

  step 'I should see a signed out message' do
    expect(page).to have_content 'Signed out successfully.'
  end

  step 'I see an invalid login message' do
    expect(page).to have_content 'Invalid login or password.'
  end

  step 'I should see an account edited message' do
    expect(page).to have_content 'You updated your account successfully.'
  end

  step 'I should see my name' do
    expect(page).to have_content @user[:name]
  end
end
