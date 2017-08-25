require 'rails_helper'

describe 'Editing project' do
  before do
    @project = create :project,
                      description: "# Here's some info about the project\n\nBla bla bla."
    login_as(create :admin)
  end

  it 'edit a project' do
    visit edit_project_path(@project)

    fill_in 'project_name',         with: ''
    fill_in 'project_description',  with: 'The project description'
    fill_in 'project_customer',     with: 'The project customer'

    click_button 'Update Project'

    expect(page).to have_content 'Alert: Project could not be updated.'

    fill_in 'project_name',       with: 'The new Project'

    click_button 'Update Project'
    @project.reload

    expect(page).to have_link 'The new Project'
    expect(page).to have_content 'The project description'
    expect(page).to have_content 'The project customer'
  end
end
