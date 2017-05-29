require 'rails_helper'

describe 'Markdown HTML optimisation' do
  it 'optimises the HTML', js: true do
    @page = create :page, creator: create(:user), content: "![](decorative-image)\n\n![Some alt text](informative-image)"
    visit page_path @page

    # The caption of an image is hidden to screen readers (as it is redundant to its alt-attribute)
    expect(page).to have_css '.figure .caption[aria-hidden="true"]', text: 'Some alt text'

    # Adds an empty alt attribute to an image if there's no alt attribute
    expect(page).to have_css '.figure img[src="decorative-image"][alt=""]'
    expect(page).to have_css '.figure img[src="informative-image"][alt="Some alt text"]'
  end
end
