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

    click_button 'Update Project'

    expect(page).to have_content 'Alert: Project could not be updated.'

    fill_in 'project_name',         with: 'The new Project'
    fill_in 'project_description',  with: 'The project description'

    expect {
      click_button 'Update Project'
      @project.reload
    } .to  change { @project.name }.to('The new Project')
      .and change { @project.description }.to('The project description')

  end
end
