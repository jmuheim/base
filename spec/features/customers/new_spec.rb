require 'rails_helper'

describe 'Creating Customer' do
  before do
    @customer = create :customer,
                        address: "# Here the Customer address\n\nBla bla bla.",
                        description: "Customer description"
    login_as(create :admin)
  end

  it 'creates a customer' do
    visit new_customer_path

    expect(page).to have_title 'Create Customer - Project Manager'
    expect(page).to have_active_navigation_items 'Customer', 'Create Customer'
    expect(page).to have_breadcrumbs 'Project Manager', 'Customer', 'Create'
    expect(page).to have_headline 'Create Customer'

    fill_in 'customer_customer',    with: ''
    fill_in 'customer_address',     with: 'New Address'
    fill_in 'customer_description', with: 'New Description'

    click_button 'Create Customer'

    expect(page).to have_flash('Customer could not be created.').of_type :alert

    fill_in 'customer_customer', with: 'New Customer'

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Create Customer'
      expect(page).to have_link 'List of Customer'
    end

    click_button 'Create Customer'

    expect(page).to have_flash 'Customer was successfully created.'
  end
end
