require 'rails_helper'

describe 'Accessibility' do
  describe 'required form fields' do
    it 'displays a visually hidden text "(required)" at the end of the label' do
      visit new_user_registration_path

      expect(page).to have_css 'label[for="user_name"]', text: 'Name (required)'
      expect(page).to have_css 'label[for="user_name"] .sr-only', text: '(required)'
    end
  end

  describe 'form validations and help blocks' do
    it 'assigns general and error help blocks with the inputs through aria-describedby', js: true do
      visit new_user_registration_path

      expect(page).to have_css '#user_password_confirmation_help' # Make sure the ID doesn't have a counter suffix, when there is only one help block
      expect(page).not_to have_css '#user_name[aria-describedby]' # Make sure no empty attributes are assigned

      fill_in 'user_password', with: 'somepassword' # Make sure that the password confirmation error is triggered
      click_button 'Sign up'

      expect(page).to have_css 'input#user_name[aria-describedby="user_name_help"]'
      expect(page).to have_css '#user_name_help'

      # When there is more than one help block, the ID has a counter suffix
      expect(page).to have_css 'input#user_password_confirmation[aria-describedby="user_password_confirmation_help_1 user_password_confirmation_help_2"]'
      expect(page).to have_css '#user_password_confirmation_help_1'
      expect(page).to have_css '#user_password_confirmation_help_2'
    end

    it 'sets the focus to the first invalid element', js: true do
      visit new_user_registration_path
      fill_in 'user_name', with: 'daisy' # Make sure the first occurring element is valid, so explicitly the second one (email) should gain focus
      click_button 'Sign up'

      # Check for focused element, see http://stackoverflow.com/questions/7940525/testing-focus-with-capybara
      expect(focused_element_id).to eq 'user_email'
    end
  end

  describe 'page title' do
    it "displays the app name suffix on every page except the home page" do
      visit root_path
      expect(page).to have_title 'Welcome to Base!'

      visit page_path(create :page, creator: create(:user))
      expect(page).to have_title 'Page test title - Base'
    end

    it 'prepends flash messages' do
      visit new_user_registration_path
      click_button 'Sign up'
      expect(page).to have_title 'Alert: User could not be created. Sign up - Base'
    end
  end
end
