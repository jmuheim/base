require 'rails_helper'

RSpec.describe "customers/show", type: :view do
  it "Doesn't render empty address" do
    assign :customer, create(:customer, address: nil)
    render
    expect(rendered).not_to have_selector('.address')
  end

  it "Doesn't render empty description" do
    assign :customer, create(:customer, description: nil)
    render
    expect(rendered).not_to have_selector('.description')
  end

  it "Doesn't render empty projects" do
    assign :customer, create(:customer, projects: [])
    render
    expect(rendered).not_to have_selector('.projects')
  end
end
