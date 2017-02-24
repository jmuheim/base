require 'rails_helper'

RSpec.describe "pages/show", type: :view do
  describe "Rendering notes" do
    before { assign :page, create(:page) }

    it 'renders to admins' do
      allow(controller).to receive(:current_user).and_return(create :admin)
      render
      expect(rendered).to have_selector('.notes')
    end

    it "doesn't render to normal users" do
      allow(controller).to receive(:current_user).and_return(create :user)
      render
      expect(rendered).not_to have_selector('.notes')
    end
  end

  describe "Rendering images" do
    before { assign :page, create(:page, :with_image) }

    it 'renders to admins' do
      allow(controller).to receive(:current_user).and_return(create :admin)
      render
      expect(rendered).to have_selector('.images')
    end

    it "doesn't render to normal users" do
      allow(controller).to receive(:current_user).and_return(create :user)
      render
      expect(rendered).not_to have_selector('.images')
    end
  end
end
