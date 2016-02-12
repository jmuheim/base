require 'rails_helper'

describe 'Markdown' do
  it 'uses Pandoc as converter for inline markdown' do
    visit page_path 'about'

    expect(page).to have_css '.footnotes' # Usual markdown converters don't do footnotes conversion, Pandoc does!
  end
end
