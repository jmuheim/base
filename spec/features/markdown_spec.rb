require 'rails_helper'

describe 'Markdown' do
  it 'uses Pandoc as converter for inline markdown' do
    visit page_path(create :page, creator: create(:user), content: "We're using Pandoc[^1], a universal document converter, to convert Markdown to HTML.\n\n[^1]: [Pandoc.org](http://pandoc.org/).")

    expect(page).to have_css '.footnotes' # Usual markdown converters don't do footnotes conversion, Pandoc does!
  end

  it 'displays an alert if installed Pandoc version is too low' do
    allow_any_instance_of(ApplicationController).to receive(:pandoc_version).and_return(1.9)
    visit root_path
    expect(page).to have_flash('Pandoc version must be at least 2.9! But current version is 1.9.').of_type :alert
  end

  it 'displays no alert if installed Pandoc version is okay' do
    visit root_path
    expect(page).not_to have_css '.alert'
  end

  it 'hides the visible figcaption from screen readers (as it is redundant to the alt-attribute)' do
    @page = create :page, creator: create(:user), content: '![Some alt text](informative-image)'
    visit page_path @page

    # 
    expect(page).to have_css 'figure figcaption[aria-hidden="true"]', text: 'Some alt text'
    expect(page).to have_css 'figure img[src="informative-image"][alt="Some alt text"]'
  end

  it "adds an empty alt attribute to images if there's no alt attribute" do
    @page = create :page, creator: create(:user), content: '![](decorative-image)'
    visit page_path @page

    expect(page).to have_css 'img[src="decorative-image"][alt=""]'
  end

  it 'hides anchors from code blocks', focus: true, js: true do
    @page = create :page, creator: create(:user), content: "```html\n<p>\nHello!\n</p>\n```"
    visit page_path @page

    find('a[href="#cb1-1"]', visible: false).assert_matches_style display: 'none'
  end
end
