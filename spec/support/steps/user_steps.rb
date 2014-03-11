# include FactoryGirl::Syntax::Methods

def valid_user_attributes
  { name:                  'Testy McUserton',
    email:                 'example@example.com',
    password:              'changeme',
    password_confirmation: 'changeme'
  }
end

def create_admin(options = {})
  options.reverse_merge! valid_user_attributes

  @user ||= create :user, options
  @user.add_role :admin
end

def create_user(options = {})
  options.reverse_merge! valid_user_attributes

  @user ||= create :user, options
end

def create_unconfirmed_user
  sign_up
  visit '/users/sign_out'
end

def sign_up(options = {})
  options.reverse_merge! valid_user_attributes

  visit '/users/sign_up'
  fill_in 'user_name',                  with: options[:name]
  fill_in 'user_email',                 with: options[:email]
  fill_in 'user_password',              with: options[:password]
  fill_in 'user_password_confirmation', with: options[:password_confirmation]
  click_button 'Sign up'
end

def sign_in_using_email(options = {})
  options.reverse_merge! email:    'example@example.com',
                         password: 'changeme'

  visit '/users/sign_in'
  fill_in 'user_login',    with: options[:email]
  fill_in 'user_password', with: options[:password]
  click_button 'Sign in'
end

def sign_in_using_name(options = {})
  options.reverse_merge! name:     'Testy McUserton',
                         password: 'changeme'

  visit '/users/sign_in'
  fill_in 'user_login',    with: options[:name]
  fill_in 'user_password', with: options[:password]
  click_button 'Sign in'
end

module UserSteps
  ### GIVEN ###
  step 'I am not logged in' do
    visit '/users/sign_out' # TODO: Use sign_out(current_user)?
  end

  step 'I am logged in as :user' do |user|
    case user
    when 'user'
      create_user
    when 'admin'
      create_admin
    else
      raise "Unknown user type #{user}"
    end

    login_as(@user)
    visit root_path
  end

  step 'I exist as a user' do
    create_user
  end

  step 'I do not exist as a user' do
    # Guest user is automatically created during the first request
  end

  step 'I exist as an unconfirmed user' do
    create_unconfirmed_user
  end

  ### WHEN ###
  step 'I sign in with valid name and password' do
    sign_in_using_name
  end

  step 'I sign in with valid email and password' do
    sign_in_using_email
  end

  step 'I sign out' do
    visit '/users/sign_out'
  end

  step 'I sign up with valid user data' do
    sign_up
  end

  step 'I sign up with an invalid email' do
    sign_up(email: 'notanemail')
  end

  step 'I sign up without a password confirmation' do
    sign_up(password_confirmation: '')
  end

  step 'I sign up without a password' do
    sign_up(password: '')
  end

  step 'I sign up with a mismatched password confirmation' do
    sign_up(password_confirmation: 'changeme123')
  end

  step 'I return to the site' do
    visit '/'
  end

  step 'I sign in with a wrong email' do
    sign_in_using_email(email: 'wrong@example.com')
  end

  step 'I sign in with a wrong password' do
    sign_in_using_name(password: 'wrongpass')
  end

  step 'I edit my account details' do
    click_link 'Edit account'
    fill_in 'user_name',             with: 'newname'
    fill_in 'user_current_password', with: @user.password
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
    expect(page).to have_content @user.name
  end

  step 'a user :name exists' do |name|
    create :user, name: name
  end

  step 'I try to request the edit page for the user :name' do |name|
    visit edit_user_path User.find_by(name: name)
  end

  step 'access should be granted' do
    expect(page.driver.status_code).to eq 200
  end

  step 'access should be denied' do
    expect(page).to have_content '403 - Forbidden'
    expect(page.driver.status_code).to eq 403
  end

  step 'I try to request the deletion of user :name' do |name|
    user = User.find_by(name: name)

    visit_delete_path_for(user)
  end

  step 'I cancel my account' do
    click_link 'Edit account'
    click_button 'Cancel my account'
  end

  step 'I should see a good bye message' do
    expect(page).to have_content 'Bye! Your account was successfully cancelled. We hope to see you again soon.'
  end
end
