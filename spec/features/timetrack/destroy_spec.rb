require 'rails_helper'

describe 'Deleting timetrack' do

  before do
    @timetrack = create :timetrack,
                        description: "# Here the Timetrack description\n\nBla bla bla.",
                        work_time: 3.00,
                        bill_time: 2.80
    login_as(create :admin)
  end

  it 'Delete a timetrack' do
    expect {
      visit_delete_path_for(@timetrack)
    }.to change { Timetrack.count }.by -1

    expect(page).to have_flash 'Notice: Timetrack was successfully destroyed.'
  end
end
