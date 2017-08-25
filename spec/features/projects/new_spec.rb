require 'rails_helper'

describe 'Creating Project' do
  before do
    @project = create :project,
                      description: "# Here's some info about the project\n\nBla bla bla."
    login_as(create :admin)
  end

  it 'creates a project' do
    visit new_project_path

    expect(page).to have_title 'Create Project - Project Manager'
    expect(page).to have_active_navigation_items 'Project', 'Create Project'
    expect(page).to have_breadcrumbs 'Project Manager', 'Project', 'Create'
    expect(page).to have_headline 'Create Project'

    fill_in 'project_name',         with: ''
    fill_in 'project_description',  with: 'New Description'

    click_button 'Create Project'

    expect(page).to have_flash('Project could not be created.').of_type :alert

    fill_in 'project_name', with: 'New Project'

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Create Project'
      expect(page).to have_link 'List of Projects'
    end

    click_button 'Create Project'

    expect(page).to have_flash 'Project was successfully created.'
  end
end
