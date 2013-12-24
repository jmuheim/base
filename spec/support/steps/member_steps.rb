### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :name => "Testy McMemberton", :email => "example@example.com",
    :password => "changeme", :password_confirmation => "changeme" }
end

def find_member
  @member ||= Member.where(:email => @visitor[:email]).first
end

def create_unconfirmed_member
  create_visitor
  delete_member
  sign_up
  visit '/members/sign_out'
end

def create_member
  create_visitor
  delete_member
  @member = FactoryGirl.create(:member, @visitor)
end

def delete_member
  @member ||= Member.where(:email => @visitor[:email]).first
  @member.destroy unless @member.nil?
end

def sign_up
  delete_member
  visit '/members/sign_up'
  fill_in "member_name", :with => @visitor[:name]
  fill_in "member_email", :with => @visitor[:email]
  fill_in "member_password", :with => @visitor[:password]
  fill_in "member_password_confirmation", :with => @visitor[:password_confirmation]
  click_button "Sign up"
  find_member
end

def sign_in
  visit '/members/sign_in'
  fill_in "member_email", :with => @visitor[:email]
  fill_in "member_password", :with => @visitor[:password]
  click_button "Sign in"
end

module MemberSteps
  ### GIVEN ###
  step 'I am not logged in' do
    visit '/members/sign_out'
  end

  step 'I am logged in' do
    create_visitor
    @member = sign_in!
    visit root_path
  end

  step 'I exist as a member' do
    create_member
  end

  step 'I do not exist as a member' do
    create_visitor
    delete_member
  end

  step 'I exist as an unconfirmed member' do
    create_unconfirmed_member
  end

  ### WHEN ###
  step 'I sign in with valid credentials' do
    create_visitor
    sign_in
  end

  step 'I sign out' do
    visit '/members/sign_out'
  end

  step 'I sign up with valid member data' do
    create_visitor
    sign_up
  end

  step 'I sign up with an invalid email' do
    create_visitor
    @visitor = @visitor.merge(:email => "notanemail")
    sign_up
  end

  step 'I sign up without a password confirmation' do
    create_visitor
    @visitor = @visitor.merge(:password_confirmation => "")
    sign_up
  end

  step 'I sign up without a password' do
    create_visitor
    @visitor = @visitor.merge(:password => "")
    sign_up
  end

  step 'I sign up with a mismatched password confirmation' do
    create_visitor
    @visitor = @visitor.merge(:password_confirmation => "changeme123")
    sign_up
  end

  step 'I return to the site' do
    visit '/'
  end

  step 'I sign in with a wrong email' do
    @visitor = @visitor.merge(:email => "wrong@example.com")
    sign_in
  end

  step 'I sign in with a wrong password' do
    @visitor = @visitor.merge(:password => "wrongpass")
    sign_in
  end

  step 'I edit my account details' do
    click_link "Edit account"
    fill_in "member_name", :with => "newname"
    fill_in "member_current_password", :with => @visitor[:password]
    click_button "Update"
  end

  step 'I look at the list of members' do
    visit members_path
  end

  ### THEN ###
  step 'I should be signed in' do
    page.should have_content "Logout"
    page.should_not have_content "Sign up"
    page.should_not have_content "Sign in"
  end

  step 'I should be signed out' do
    page.should have_content "Sign up"
    page.should have_content "Sign in"
    page.should_not have_content "Logout"
  end

  step 'I see an unconfirmed account message' do
    page.should have_content "You have to confirm your account before continuing."
  end

  step 'I see a successful sign in message' do
    page.should have_content "Signed in successfully."
  end

  step 'I should see a confirmation has been sent message' do
    page.should have_content "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
  end

  step 'I should see a successful sign up message' do
    page.should have_content "Welcome! You have signed up successfully."
  end

  step 'I should see an invalid email message' do
    page.should have_content "Email is invalid"
  end

  step 'I should see a missing password message' do
    page.should have_content "Password can't be blank"
  end

  step 'I should see a missing password confirmation message' do
    page.should have_content "Password confirmation doesn't match"
  end

  step 'I should see a mismatched password message' do
    page.should have_content "Password confirmation doesn't match"
  end

  step 'I should see a signed out message' do
    page.should have_content "Signed out successfully."
  end

  step 'I see an invalid login message' do
    page.should have_content "Invalid email or password."
  end

  step 'I should see an account edited message' do
    page.should have_content "You updated your account successfully."
  end

  step 'I should see my name' do
    create_member
    page.should have_content @member[:name]
  end
end
