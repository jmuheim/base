require 'rails_helper'

RSpec.describe 'customers/index' do
  it "Doesn't render empty address" do
    assign :customers, [create(:customer, address: nil)]
    render

    expect(rendered).to have_css('.address:not(pre)')
  end

  it "Doesn't render empty description" do
    assign :customers, [create(:customer, description: nil)]
    render

    expect(rendered).to have_css('.description:not(pre)')
  end
end
