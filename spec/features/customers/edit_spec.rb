require 'rails_helper'

describe 'Editing customer' do
  before do
    @customer = create :customer

    login_as(create :admin)
  end

  it 'edit a customer' do
    visit edit_customer_path(@customer)

    fill_in 'customer_customer',         with: ''

    click_button 'Update Customer'

    expect(page).to have_content 'Alert: Customer could not be updated.'

    fill_in 'customer_customer',    with: 'The new Customer'
    fill_in 'customer_address',     with: 'The customer address'
    fill_in 'customer_description', with: 'The customer description'

    expect {
      click_button 'Update Customer'
      @customer.reload
    } .to  change { @customer.customer }.to('The new Customer')
      .and change { @customer.address }.to('The customer address')
      .and change { @customer.description}.to('The customer description')

  end
end
