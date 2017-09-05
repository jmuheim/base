require 'rails_helper'

describe 'Creating Timetrack' do
  before do
    login_as(create :admin)
  end

  it 'creates a timetrack' do
    visit new_timetrack_path

    expect(page).to have_title 'Create Timetrack - Project Manager'
    expect(page).to have_active_navigation_items 'Timetrack', 'Create Timetrack'
    expect(page).to have_breadcrumbs 'Project Manager', 'Timetrack', 'Create'
    expect(page).to have_headline 'Create Timetrack'

    fill_in 'timetrack_name',         with: ''
    fill_in 'timetrack_description',  with: 'New Description'
    fill_in 'timetrack_work_time',    with: '2.5'

    click_button 'Create Timetrack'

    expect(page).to have_flash('Timetrack could not be created.').of_type :alert

    fill_in 'timetrack_name', with: 'New Timetrack'

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Create Timetrack'
      expect(page).to have_link 'List of Timetrack'
    end

    click_button 'Create Timetrack'

    expect(page).to have_flash 'Timetrack was successfully created.'
  end
end
