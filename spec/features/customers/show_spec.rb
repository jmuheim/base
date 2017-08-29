require 'rails_helper'

describe 'Showing customer' do
  before do
    @customer = create :customer,
                        address: "# Here the Customer address\n\nBla bla bla.",
                        description: "Customer description"
    login_as(create :admin)
  end

  it 'displays a customer' do
    visit customer_path(@customer)

    expect(page).to have_title 'Customer test name - Project Manager'
    expect(page).to have_active_navigation_items 'Customer', 'List of Customer'
    expect(page).to have_breadcrumbs 'Project Manager', 'Customer', 'Customer test name'
    expect(page).to have_headline 'Customer test name'

    within dom_id_selector(@customer) do
      expect(page).to have_css '.created_at', text: '15 Jun 14:33'
      expect(page).to have_css '.updated_at', text: '15 Jun 14:33'

      within '.address' do
        expect(page).to have_css 'h2', text: 'Address'
        expect(page).to have_content 'Here the Customer address'
      end

      within '.description' do
        expect(page).to have_css 'h2', text: 'Description'
        expect(page).to have_content 'Customer description'
      end

      within '.actions' do
        expect(page).to have_css 'h2', text: 'Actions'
        expect(page).to have_link 'Edit'
        expect(page).to have_link 'Delete'
        expect(page).to have_link 'Create Customer'
        expect(page).to have_link 'List of Customer'
      end
    end
  end

  # The more thorough tests are implemented for pages#show. As we simply render the same partial here, we just make sure the container is there.
  it 'displays versions (if authorized)', versioning: true do
    visit customer_path(@customer)

    within '.versions' do
      expect(page).to have_css 'h2', text: 'Versions (1)'
    end

    login_as(create :user, :donald)
    visit customer_path(@customer)
    expect(page).not_to have_css '.versions'
  end
end
