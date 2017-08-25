require 'rails_helper'

describe 'Deleting project' do

  before do
    @project = create :project,
                      description: "# Here's some info about the project\n\nBla bla bla."
    login_as(create :admin)
  end

  it 'Delete a project' do
    expect {
      visit_delete_path_for(@project)
    }.to change { Project.count }.by -1

    expect(page).to have_flash 'Notice: Project was successfully destroyed.'
  end
end
