require 'rails_helper'

describe 'Deleting customer' do

  before do
    @customer = create :customer,
                        address: "# Here the Customer address\n\nBla bla bla.",
                        description: "Customer description"
    login_as(create :admin)
  end

  it 'Delete a customer' do
    expect {
      visit_delete_path_for(@customer)
    }.to change { Customer.count }.by -1

    expect(page).to have_flash 'Notice: Customer was successfully destroyed.'
  end
end
