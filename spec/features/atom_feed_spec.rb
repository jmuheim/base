require 'rails_helper'

describe 'ATOM feed' do
  it 'provides an auto discovery link tag for the pages feed' do
    visit root_path

    # Auto discovery link
    within 'head', visible: false do
      expect(page).to have_css 'link[rel="alternate"][type="application/atom+xml"][title="Pages"][href="/en/pages.atom"]', visible: false
    end

    within 'footer .atom' do
      expect(page).to have_link 'Atom Feed'
    end
  end
end
