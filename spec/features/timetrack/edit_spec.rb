require 'rails_helper'

describe 'Editing timetrack' do
  before do
    @timetrack = create :timetrack,
                        description: "# Here's some info about the timetrack\n\nBla bla bla.",
                        bill_time: 2.80
    login_as(create :admin)
  end

  it 'edit a timetrack' do
    visit edit_timetrack_path(@timetrack)

    fill_in 'timetrack_name', with: ''

    click_button 'Update Timetrack'

    expect(page).to have_content 'Alert: Timetrack could not be updated.'

    fill_in 'timetrack_name',        with: 'The new Name'
    fill_in 'timetrack_description', with: 'The timetrack description'
    fill_in 'timetrack_work_time',   with: 2.6

    expect {
      click_button 'Update Timetrack'
      @timetrack.reload
    } .to  change { @timetrack.name }.to('The new Name')
      .and change { @timetrack.description}.to('The timetrack description')
      .and change { @timetrack.work_time}.to(2.6)

  end
end
