require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  it "Doesn't render empty description" do
    assign :project, create(:project, description: nil)
    render
    expect(rendered).not_to have_selector('.description')
  end

  it "Doesn't render empty customer" do
    assign :project, create(:project, customer: nil)
    render
    expect(rendered).not_to have_selector('.customer')
  end
end
