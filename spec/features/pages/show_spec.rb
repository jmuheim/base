require 'rails_helper'

describe 'Showing page' do
  before { login_as(create :admin) }

  it 'displays a page' do
    other_page = create :page, title: 'Some cool other page'
    parent_page = create(:page, title: 'Cool parent page', navigation_title: nil)
    child_page = create(:page, title: 'A cool sub page', lead: 'Some sub page lead')
    @page = create :page, :with_image,
                          navigation_title: 'Page test navigation title',
                          lead:   "# Some lead title\n\nAnd some lead stuff.",
                          content: "# Some content title\n\nAnd some content stuff.\n\n![Content image](@image-Image test identifier) with a [](@page-#{other_page.id}) and [some alt](@page-#{other_page.id})",
                          notes:   "# Some notes title\n\nAnd some notes stuff.\n\n![Notes image](@image-Image test identifier) with a [](@page-#{other_page.id}) and [some alt](@page-#{other_page.id})",
                          parent:  parent_page,
                          children: [child_page]
    sibling_page = create :page, title: 'Other page', navigation_title: 'Sibling page', parent: parent_page

    visit page_path(@page)

    expect(page).to have_title 'Page test title - Base'
    expect(page).to have_active_navigation_items 'Page test navigation title'
    expect(page).to have_breadcrumbs 'Base', 'Cool parent page', 'Page test navigation title'
    expect(page).to have_headline 'Page test title'

    within dom_id_selector(@page) do
      within '.lead' do
        expect(page).to have_css 'h2', text: 'Lead'
        expect(page).to have_css 'h3', text: 'Some lead title'
        expect(page).to have_content 'And some lead stuff'
      end

      within '.content' do
        expect(page).to have_css 'h2', text: 'Some content title'
        expect(page).to have_content 'And some content stuff'
        expect(page).to have_css "img[alt='Content image'][src='#{@page.images.last.file.url}']"
        expect(page).to have_css "a[href='/en/pages/#{other_page.id}']", text: 'Some cool other page'
        expect(page).to have_css "a[href='/en/pages/#{other_page.id}'][title='Some cool other page']", text: 'some alt'
      end

      within '.notes' do
        expect(page).to have_css 'h2', text: 'Notes'
        expect(page).to have_css 'h3', text: 'Some notes title'
        expect(page).to have_content 'And some notes stuff'
        expect(page).to have_css "img[alt='Notes image'][src='#{@page.images.last.file.url}']"
        expect(page).to have_css "a[href='/en/pages/#{other_page.id}']", text: 'Some cool other page'
        expect(page).to have_css "a[href='/en/pages/#{other_page.id}'][title='Some cool other page']", text: 'some alt'
      end

      within '.browsing' do
        expect(page).to have_css "a[href='/en/pages/#{parent_page.id}']", text: 'Previous page: Cool parent page'
        expect(page).to have_css "a[href='/en/pages/#{child_page.id}']", text: 'Next page: A cool sub page'
      end

      within '.children' do
        expect(page).to have_css 'h2', text: 'Sub pages'
        expect(page).to have_css 'h3', text: 'A cool sub page'
        expect(page).to have_css 'p', text: 'Some sub page lead'
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

  it 'offers links to browse page by page (previous page / next page) like a book' do
    @root_1                 = create :page, title: 'Root 1'
    @root_1_child_1         = create :page, title: 'Root 1 child 1',         parent: @root_1
    @root_1_child_2         = create :page, title: 'Root 1 child 2',         parent: @root_1
    @root_1_child_2_child_1 = create :page, title: 'Root 1 child 2 child 1', parent: @root_1_child_2
    @root_2                 = create :page, title: 'Root 2'
    @root_2_child_1         = create :page, title: 'Root 2 child 1',         parent: @root_2

    visit page_path(@root_1)
    expect(page).to have_css '.previous.disabled', text: 'No previous page'
    expect(page).to have_link 'Next page: Root 1 child 1'

    click_link 'Next page: Root 1 child 1'
    expect(page).to have_link 'Previous page: Root 1'

    click_link 'Next page: Root 1'
    expect(page).to have_link 'Previous page: Root 1 child 1'

    click_link 'Next page: Root 1 child 2 child 1'
    expect(page).to have_link 'Previous page: Root 1 child 2'

    click_link 'Next page: Root 2'
    expect(page).to have_link 'Previous page: Root 1 child 2 child 1'

    click_link 'Next page: Root 2 child 1'
    expect(page).to have_link 'Previous page: Root 2'
    expect(page).to have_css '.next.disabled', text: 'No next page'
  end
end
