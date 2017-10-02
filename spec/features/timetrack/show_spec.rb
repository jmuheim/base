require 'rails_helper'

describe 'Showing timetrack' do
  before do
    @timetrack = create :timetrack,
                        description: "# Here's some info about the timetrack\n\nBla bla bla."
    login_as(create :admin)
  end

  it 'displays a timetrack' do
    visit timetrack_path(@timetrack)

    expect(page).to have_title 'Timetrack test name - Project Manager'
    expect(page).to have_active_navigation_items 'Timetrack', 'List of Timetrack'
    expect(page).to have_breadcrumbs 'Project Manager', 'Timetrack', 'Timetrack test name'
    expect(page).to have_headline 'Timetrack test name'

    within dom_id_selector(@timetrack) do
      expect(page).to have_css '.created_at', text: '15 Jun 14:33'
      expect(page).to have_css '.updated_at', text: '15 Jun 14:33'

      within '.description' do
        expect(page).to have_css 'h2', text: 'Description'
        expect(page).to have_css 'h3', text: "Here's some info about the timetrack"
        expect(page).to have_content 'Bla bla bla'
      end

      within '.work_time' do
        expect(page).to have_css 'h2', text: 'Work time'
      end

      within '.bill_time' do
        expect(page).to have_css 'h2', text: 'Bill time'
      end
      within '.actions' do
        expect(page).to have_css  'h2', text: 'Actions'
        expect(page).to have_link 'Edit'
        expect(page).to have_link 'Delete'
        expect(page).to have_link 'Create Timetrack'
        expect(page).to have_link 'List of Timetrack'
      end
    end
  end

  # The more thorough tests are implemented for pages#show. As we simply render the same partial here, we just make sure the container is there.
  it 'displays versions (if authorized)', versioning: true do
    visit timetrack_path(@timetrack)

    within '.versions' do
      expect(page).to have_css 'h2', text: 'Versions (1)'
    end

    login_as(create :user, :donald)
    visit timetrack_path(@timetrack)
    expect(page).not_to have_css '.versions'
  end
end
