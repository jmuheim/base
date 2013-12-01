module Turnip
  module Steps
    step "I'm a guest" do
      # Do nothing
    end

    step 'I visit the dashboard' do
      visit dashboard_path
    end

    step 'the welcome message is displayed' do
      expect(page).to have_content 'Welcome, guest!'
    end
  end
end
