require 'rails_helper'

describe 'Showing page' do
  before { login_as(create :admin) }

  it 'displays a page' do
    @page = create :page, :with_image,
                          content: "# Some content title\n\nAnd some content stuff.\n\n![And an image](Image test identifier)",
                          notes:   "# Some notes title\n\nAnd some notes stuff."

    visit page_path(@page)

    expect(page).to have_title 'Page test title - Base'
    expect(page).to have_active_navigation_items 'Page test navigation title'
    expect(page).to have_breadcrumbs 'Base', 'Page test navigation title'
    expect(page).to have_headline 'Page test title'

    within dom_id_selector(@page) do
      within '.content' do
        expect(page).to have_css 'h2', text: 'Some content title'
        expect(page).to have_content 'And some content stuff'
        expect(page).to have_css 'img[alt="And an image"][src="/uploads/image/file/1/image.jpg"]'
      end

      within '.notes' do
        expect(page).to have_css 'h2', text: 'Notes'
        expect(page).to have_css 'h3', text: 'Some notes title'
        expect(page).to have_content 'And some notes stuff'
      end

      within '.actions' do
        expect(page).to have_css 'h2', text: 'Actions'

        expect(page).to have_link 'Edit'
        expect(page).to have_link 'Delete'
        expect(page).to have_link 'Create Page'
        expect(page).to have_link 'List of Pages'
      end
    end

    within '.images' do
      expect(page).to have_css 'h2', text: 'Images'
      expect(page).to have_css "a[href='#{@page.images.last.file.url}'] img[alt='Thumb image'][src='#{@page.images.last.file.url(:thumb)}']"
    end
  end
end
