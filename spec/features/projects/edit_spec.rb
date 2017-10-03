require 'rails_helper'

describe 'Editing project' do
  before do
    @project = create :project,
                      :with_customer,
                      description: "# Here's some info about the project\n\nBla bla bla."

    @other_customer = create :customer, name: 'Other customer'

    login_as(create :admin)
  end

  it 'edit a project' do
    visit edit_project_path(@project)

    fill_in 'project_name', with: ''

    click_button 'Update Project'

    expect(page).to have_content 'Alert: Project could not be updated.'


    select 'Other customer', from: 'project_customer_id'
    fill_in 'project_name',         with: 'The new Project'
    fill_in 'project_description',  with: 'The project description'

    expect {
      click_button 'Update Project'
      @project.reload
    } .to  change { @project.name }.to('The new Project')
      .and change { @project.customer }.to(@other_customer)
      .and change { @project.description }.to('The project description')
  end
end
