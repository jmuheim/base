require 'rails_helper'

describe 'Editing project' do
  before do
    @project = create :project, description: "# Here's some info about the project\n\nBla bla bla."
    
  end

  it 'edit a project' do
    visit edit_project_path(@project)

    expect(page).have_flash 'You are not authorized to access this page.'
    #login_as(create :admin)


  end
end
