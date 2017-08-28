require 'rails_helper'

describe 'Showing project' do
  before do
    @project = create :project,
                      description: "# Here's some info about the project\n\nBla bla bla."
    login_as(create :admin)
  end

  it 'displays a project' do
    visit project_path(@project)

    expect(page).to have_title 'Project test name - Project Manager'
    expect(page).to have_active_navigation_items 'Projects'
    expect(page).to have_breadcrumbs 'Project Manager', 'Projects', 'Project test name'
    expect(page).to have_headline 'Project test name'

    within dom_id_selector(@project) do
      expect(page).to have_css '.created_at', text: '15 Jun 14:33'
      expect(page).to have_css '.updated_at', text: '15 Jun 14:33'

      within '.description' do
        expect(page).to have_css 'h2', text: 'Description'
        expect(page).to have_css 'h3', text: "Here's some info about the project"
        expect(page).to have_content 'Bla bla bla.'
      end

      within '.actions' do
        expect(page).to have_css 'h2', text: 'Actions'

        expect(page).to have_link 'Edit'
        expect(page).to have_link 'Delete'
        expect(page).to have_link 'Create Project'
        expect(page).to have_link 'List of Projects'
      end
    end
  end

  # The more thorough tests are implemented for pages#show. As we simply render the same partial here, we just make sure the container is there.
  it 'displays versions (if authorized)', versioning: true do
    visit project_path(@project)

    within '.versions' do
      expect(page).to have_css 'h2', text: 'Versions (1)'
    end

    login_as(create :user, :donald)
    visit project_path(@project)
    expect(page).not_to have_css '.versions'
  end
end
