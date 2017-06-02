require 'rails_helper'

describe 'Markdown' do
  it 'uses Pandoc as converter for inline markdown' do
    visit page_path(create :page, creator: create(:user), content: "We're using Pandoc[^1], a universal document converter, to convert Markdown to HTML.\n\n[^1]: [Pandoc.org](http://pandoc.org/).")

    expect(page).to have_css '.footnotes' # Usual markdown converters don't do footnotes conversion, Pandoc does!
  end
end
