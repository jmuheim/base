require 'rails_helper'

describe 'Listing projects' do
  before do
    @project = create :project,
                      description: "# Here's some info about the project\n\nBla bla bla."
    login_as(create :admin)
  end

  it 'displays projects' do
    visit projects_path

    expect(page).to have_title 'Projects - Project Manager'
    expect(page).to have_active_navigation_items 'Projects', 'List of Projects'
    expect(page).to have_breadcrumbs 'Project Manager', 'Projects'
    expect(page).to have_headline 'Projects'

    within dom_id_selector(@project) do
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    within 'div.actions' do
      expect(page).to have_css 'h2', text: 'Actions'
      expect(page).to have_link 'Create Project'
    end
  end
end
