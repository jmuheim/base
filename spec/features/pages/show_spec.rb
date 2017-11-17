require 'rails_helper'

describe 'Showing page' do
  before do
    @user = create :user
    login_as(@user)
  end

  it 'displays a page' do
    other_page = create :page, creator: @user, title: 'Some cool other page'
    parent_page = create(:page, creator: @user, title: 'Cool parent page', navigation_title: nil)
    child_page = create(:page, creator: @user, title: 'A cool sub page', navigation_title: 'Really cool sub page', lead: 'Some sub page lead')
    @page = create :page, navigation_title: 'Page test navigation title',
                          images: [create(:image, creator: @user)],
                          lead:   "# Some lead title\n\nAnd some lead stuff. [some alt](@page-#{other_page.id})",
                          content: "# Some content title\n\nAnd some content stuff.\n\n![Content image](@image-Image test identifier) with a [](@page-#{other_page.id}) and [some alt](@page-#{other_page.id})",
                          notes:   "# Some notes title\n\nAnd some notes stuff.\n\n![Notes image](@image-Image test identifier) with a [](@page-#{other_page.id}) and [some alt](@page-#{other_page.id})",
                          parent:  parent_page,
                          children: [child_page],
                          creator: @user
    sibling_page = create :page, creator: @user, title: 'Other page', navigation_title: 'Sibling page', parent: parent_page

    visit page_path(@page)

    expect(page).to have_title 'Page test title - Base'
    expect(page).to have_active_navigation_items 'Page test navigation title'
    expect(page).to have_breadcrumbs 'Base', 'Cool parent page', 'Page test navigation title'
    expect(page).to have_headline 'Page test title'

    within dom_id_selector(@page) do
      within '.lead' do
        expect(page).to have_css 'h2', text: 'Some lead title'
        expect(page).to have_content 'And some lead stuff'
        expect(page).to have_css "a[href='/en/pages/#{other_page.id}'][title='Some cool other page']", text: 'some alt'
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
        expect(page).to have_css 'h3.h2', text: 'Some notes title'
        expect(page).to have_content 'And some notes stuff'
        expect(page).to have_css "img[alt='Notes image'][src='#{@page.images.last.file.url}']"
        expect(page).to have_css "a[href='/en/pages/#{other_page.id}']", text: 'Some cool other page'
        expect(page).to have_css "a[href='/en/pages/#{other_page.id}'][title='Some cool other page']", text: 'some alt'
      end

      within '.browsing' do
        expect(page).to have_css "a[href='/en/pages/#{parent_page.id}']", text: 'Previous page: Cool parent page'
        expect(page).to have_css "a[href='/en/pages/#{child_page.id}']", text: 'Next page: Really cool sub page'
      end

      within '.additional_information' do
        expect(page).to have_css '.creator', text: 'User test admin-name'
        expect(page).to have_css '.created_at', text: 'Mon, 15 Jun 2015 14:33:52 +0200'
        expect(page).to have_css '.updated_at', text: 'Mon, 15 Jun 2015 14:33:52 +0200'
      end

      within '.children' do
        expect(page).to have_css 'h2', text: 'Sub pages'
        expect(page).to have_css 'h3', text: 'A cool sub page'
        expect(page).to have_css 'p', text: 'Some sub page lead'
      end

      within '.pastables' do
        expect(page).to have_css 'h2', text: 'Images (1)'
        # No codes available
      end

      within '.actions' do
        expect(page).to have_css 'h2', text: 'Actions'

        expect(page).to have_link 'Edit'
        expect(page).to have_link 'Delete'
        expect(page).to have_link 'Create Page'
        expect(page).to have_link 'List of Pages'
      end
    end
  end

  it 'offers links to browse page by page (previous page / next page) like a book' do
    @root_1                 = create :page, navigation_title: nil, title: 'Root 1',                 creator: @user
    @root_1_child_1         = create :page, navigation_title: nil, title: 'Root 1 child 1',         creator: @user, parent: @root_1
    @root_1_child_2         = create :page, navigation_title: nil, title: 'Root 1 child 2',         creator: @user, parent: @root_1
    @root_1_child_2_child_1 = create :page, navigation_title: nil, title: 'Root 1 child 2 child 1', creator: @user, parent: @root_1_child_2
    @root_2                 = create :page, navigation_title: nil, title: 'Root 2',                 creator: @user
    @root_2_child_1         = create :page, navigation_title: nil, title: 'Root 2 child 1',         creator: @user, parent: @root_2

    visit page_path(@root_1)
    expect(page).to have_css '.previous[disabled]', text: 'No previous page'
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
    expect(page).to have_css '.next[disabled]', text: 'No next page'
  end

  describe 'images' do
    it "doesn't display images if none available" do
      @page = create :page, creator: @user
      visit page_path(@page)

      expect(page).not_to have_css '.images'
    end

    it 'displays images if available (if authorized)' do
      @page = create :page, images: [create(:image, creator: @user)], creator: @user
      visit page_path(@page)

      within '.images' do
        expect(page).to have_css 'h2', text: 'Images (1)'

        within '#image_1' do
          expect(page).to have_css ".image a[href='#{@page.images.last.file.url}'] img[alt='Thumb image'][src='#{@page.images.last.file.url(:thumb)}']"
          expect(page).to have_css '.identifier',   text: 'Image test identifier'
          expect(page).to have_css '.creator a',    text: 'User test admin-name'
          expect(page).to have_css '.created_at',   text: 'Mon, 15 Jun 2015 14:33:52 +0200'
          expect(page).to have_css '.updated_at',   text: 'Mon, 15 Jun 2015 14:33:52 +0200'
        end
      end

      login_as(create :user)
      visit page_path(@page)
      expect(page).not_to have_css '.images'
    end
  end

  describe 'codes' do
    it "doesn't display codes if none available" do
      @page = create :page, creator: @user
      visit page_path(@page)

      expect(page).not_to have_css '.codes'
    end

    it 'displays codes if available (if authorized)' do
      @page = create :page, codes: [create(:code, creator: @user)], creator: @user
      visit page_path(@page)

      within '.codes' do
        expect(page).to have_css 'h2', text: 'Codes'

        within '#code_1' do
          expect(page).to have_css '.identifier',   text: 'jmuheim-PipApO'
          expect(page).to have_css '.title',        text: 'Code test title'
          expect(page).to have_css '.url a',        text: 'https://codepen.io/jmuheim/pen/PipApO'
          expect(page).to have_css '.creator a', text: 'User test admin-name'
          expect(page).to have_css '.created_at',   text: 'Mon, 15 Jun 2015 14:33:52 +0200'
          expect(page).to have_css '.updated_at',   text: 'Mon, 15 Jun 2015 14:33:52 +0200'
        end
      end

      login_as(create :user)
      visit page_path(@page)
      expect(page).not_to have_css '.images'
    end
  end

  describe 'versioning' do
    it "doesn't display versions if none available" do
      @page = create :page, creator: @user
      visit page_path(@page)

      expect(page).not_to have_css '.versions'
    end

    it 'displays versions if available (if authorized)', versioning: true do
      @page = create :page, creator: @user
      @page.update_attributes! title: 'This is a new title',
                               lead:  'And a new lead'
      @page.update_attributes! title:   'And another title',
                               content: 'And some other content'

      Mobility.with_locale(:de) do
        @page.update_attributes! title:   'Und ein anderer Titel',
                                 content: 'Und ein anderer Inhalt'
      end

      visit page_path(@page)

      within '.versions' do
        expect(page).to have_css 'h2', text: 'Versions (4)'

        within '#version_5_title_de' do
          expect(page).to have_css '.count      .first_occurrence', text: 4
          expect(page).to have_css '.event      .first_occurrence', text: 'Update'
          expect(page).to have_css '.created_at .first_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.attribute',        text: 'Title (de)'
          expect(find('.value_before').text).to eq ''
          expect(page).to have_css '.value_after',      text: 'Und ein anderer Titel'
          expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
        end

        within '#version_5_content_de' do
          expect(page).to have_css '.count      .recurrent_occurrence', text: 4
          expect(page).to have_css '.event      .recurrent_occurrence', text: 'Update'
          expect(page).to have_css '.created_at .recurrent_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.attribute',        text: 'Content (de)'
          expect(find('.value_before').text).to eq ''
          expect(page).to have_css '.value_after',      text: 'Und ein anderer Inhalt'
          expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
        end

        within '#version_4_title_en' do
          expect(page).to have_css '.count      .first_occurrence', text: 3
          expect(page).to have_css '.event      .first_occurrence', text: 'Update'
          expect(page).to have_css '.created_at .first_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.attribute',        text: 'Title'
          expect(page).to have_css '.value_before',     text: 'This is a new title'
          expect(page).to have_css '.value_after',      text: 'And another title'
          expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
        end

        within '#version_4_content_en' do
          expect(page).to have_css '.count      .recurrent_occurrence', text: 3
          expect(page).to have_css '.event      .recurrent_occurrence', text: 'Update'
          expect(page).to have_css '.created_at .recurrent_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.attribute',        text: 'Content'
          expect(page).to have_css '.value_before',     text: 'Page test content'
          expect(page).to have_css '.value_after',      text: 'And some other content'
          expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
        end

        within '#version_3_title_en' do
          expect(page).to have_css '.count      .first_occurrence', text: 2
          expect(page).to have_css '.event      .first_occurrence', text: 'Update'
          expect(page).to have_css '.created_at .first_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.attribute',        text: 'Title'
          expect(page).to have_css '.value_before',     text: 'Page test title'
          expect(page).to have_css '.value_after',      text: 'This is a new title'
          expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
        end

        within '#version_3_lead_en' do
          expect(page).to have_css '.count      .recurrent_occurrence', text: 2
          expect(page).to have_css '.event      .recurrent_occurrence', text: 'Update'
          expect(page).to have_css '.created_at .recurrent_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.attribute',        text: 'Lead'
          expect(page).to have_css '.value_before',     text: 'Page test lead'
          expect(page).to have_css '.value_after',      text: 'And a new lead'
          expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
        end

        within '#version_2_notes' do
          expect(page).to have_css '.count      .recurrent_occurrence', text: 1
          expect(page).to have_css '.event      .recurrent_occurrence', text: 'Create'
          expect(page).to have_css '.created_at .recurrent_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.attribute',        text: 'Notes'
          expect(find('.value_before').text).to eq ''
          expect(page).to have_css '.value_after',      text: 'Page test notes'
          expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
        end

        within '#version_2_title_en' do
          expect(page).to have_css '.count      .first_occurrence', text: 1
          expect(page).to have_css '.event      .first_occurrence', text: 'Create'
          expect(page).to have_css '.created_at .first_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.attribute',        text: 'Title'
          expect(find('.value_before').text).to eq ''
          expect(page).to have_css '.value_after',      text: 'Page test title'
          expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
        end

        within '#version_2_navigation_title_en' do
          expect(page).to have_css '.count      .recurrent_occurrence', text: 1
          expect(page).to have_css '.event      .recurrent_occurrence', text: 'Create'
          expect(page).to have_css '.created_at .recurrent_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.attribute',        text: 'Navigation title'
          expect(find('.value_before').text).to eq ''
          expect(page).to have_css '.value_after',      text: 'Page test navigation title'
          expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
        end

        within '#version_2_content_en' do
          expect(page).to have_css '.count      .recurrent_occurrence', text: 1
          expect(page).to have_css '.event      .recurrent_occurrence', text: 'Create'
          expect(page).to have_css '.created_at .recurrent_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.attribute',        text: 'Content'
          expect(find('.value_before').text).to eq ''
          expect(page).to have_css '.value_after',      text: 'Page test content'
          expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
        end
      end

      login_as(create :user)
      visit page_path(@page)
      expect(page).not_to have_css '.versions'
    end

    it 'displays empty versions if available', versioning: true do
      @page = create :page, creator: @user
      @page.versions.last.update_attribute :object_changes, nil

      visit page_path(@page)

      within '.versions' do
        expect(page).to have_css 'h2', text: 'Versions (1)'

        within '#version_2' do
          expect(page).to have_css '.count      .first_occurrence', text: 1
          expect(page).to have_css '.event      .first_occurrence', text: 'Create'
          expect(page).to have_css '.created_at .first_occurrence', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

          expect(page).to have_css '.no_changes', text: 'No changes in this version'
        end
      end
    end

    it "generates a diff view", versioning: true, js: true do
      @page = create :page, creator: @user
      visit page_path(@page)

      expect(page.html).to include '<pre data-diff-result=""><ins style="background:#e6ffe6;">Page test title</ins></pre>'
    end
  end
end