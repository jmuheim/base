require 'rails_helper'

describe 'Table sorting', js: true do
  before do
    @user_aaa = create :user, name: 'aaa', email: 'aaa@email.com'
    login_as @user_aaa
  end

  it 'manages GUI as expected when interacting' do
    visit users_path

    expect(page).to have_css '.name     button[aria-sort="ascending"]' # Due to th.name data-sort-initial="ascending"
    expect(page).to have_css '.avatar   button[aria-sort="none"]'
    expect(page).to have_css '.disabled button[aria-sort="none"]'

    within 'thead' do
      # Sorts ascending on first click
      expect {
        click_button 'Email'
      }.to change { find('.email button')['aria-sort'] }.from('none').to('ascending')
      .and change { find('.name button')['aria-sort'] }.from('ascending').to 'none' # Reset previous

      # Sorts ascending on second click
      expect {
        click_button 'Email'
      }.to change { find('.email button')['aria-sort'] }.from('ascending').to 'descending'

      # Sorts another element ascending again on 1st click
      expect {
        click_button 'Role'
      }.to change { find('.role button')['aria-sort'] }.from('none').to('ascending')
      .and change { find('.email button')['aria-sort'] }.from('descending').to 'none' # Reset previous
    end
  end

  describe 'sorting' do
    before do
      @user_ccc = create :user, name: 'ccc', email: 'ccc@email.com'
      @user_bbb = create :user, name: 'bbb', email: 'bbb@email.com'
    end

    context 'text' do
      it 'sorts up and down' do
        visit users_path

        expect(page).to have_css "tr#user_#{@user_aaa.id}:nth-child(1)"
        expect(page).to have_css "tr#user_#{@user_bbb.id}:nth-child(2)"
        expect(page).to have_css "tr#user_#{@user_ccc.id}:nth-child(3)"

        click_button 'Name'

        expect(page).to have_css "tr#user_#{@user_ccc.id}:nth-child(1)"
        expect(page).to have_css "tr#user_#{@user_bbb.id}:nth-child(2)"
        expect(page).to have_css "tr#user_#{@user_aaa.id}:nth-child(3)"
      end
    end

    context 'image alt texts' do
      it 'sorts up and down' do
        @user_aaa.update avatar: File.open(dummy_file_path('image.jpg'))
        @user_ccc.update avatar: File.open(dummy_file_path('image.jpg'))

        visit users_path

        expect(page).to have_css "tr#user_#{@user_aaa.id}:nth-child(1)"
        expect(page).to have_css "tr#user_#{@user_bbb.id}:nth-child(2)"
        expect(page).to have_css "tr#user_#{@user_ccc.id}:nth-child(3)"

        click_button 'Profile picture'

        expect(page).to have_css "tr#user_#{@user_bbb.id}:nth-child(1)" # No avatar
        expect(page).to have_css "tr#user_#{@user_aaa.id}:nth-child(2)"
        expect(page).to have_css "tr#user_#{@user_ccc.id}:nth-child(3)"

        click_button 'Profile picture'

        expect(page).to have_css "tr#user_#{@user_ccc.id}:nth-child(1)"
        expect(page).to have_css "tr#user_#{@user_aaa.id}:nth-child(2)"
        expect(page).to have_css "tr#user_#{@user_bbb.id}:nth-child(3)" # No avatar
      end
    end

    context 'natural numbers' do
      it 'sorts up and down' do
        @user_aaa.update name: 5
        @user_bbb.update name: 333
        @user_ccc.update name: 10

        visit users_path

        # ActiveRecord orders by comparing strings, so initial sort is "wrong" (that's exactly why we implement this special sort mechanism for numbers)
        expect(page).to have_css "tr#user_#{@user_ccc.id}:nth-child(1)"
        expect(page).to have_css "tr#user_#{@user_bbb.id}:nth-child(2)"
        expect(page).to have_css "tr#user_#{@user_aaa.id}:nth-child(3)"

        click_button 'Name'

        expect(page).to have_css "tr#user_#{@user_bbb.id}:nth-child(1)"
        expect(page).to have_css "tr#user_#{@user_ccc.id}:nth-child(2)"
        expect(page).to have_css "tr#user_#{@user_aaa.id}:nth-child(3)"

        click_button 'Name'

        expect(page).to have_css "tr#user_#{@user_aaa.id}:nth-child(1)"
        expect(page).to have_css "tr#user_#{@user_ccc.id}:nth-child(2)"
        expect(page).to have_css "tr#user_#{@user_bbb.id}:nth-child(3)"
      end
    end

    it 'uses data-sort attribute if available' do
      visit users_path

      @user_aaa.update email: 'bbb@email.com'
      @user_bbb.update email: 'ccc@email.com'
      @user_ccc.update email: 'aaa@email.com'

      visit users_path

      click_button 'Email' # Sorts after name (using data-sort attribute) in test env!

      expect(page).to have_css "tr#user_#{@user_aaa.id}:nth-child(1)"
      expect(page).to have_css "tr#user_#{@user_bbb.id}:nth-child(2)"
      expect(page).to have_css "tr#user_#{@user_ccc.id}:nth-child(3)"

      click_button 'Email'

      expect(page).to have_css "tr#user_#{@user_ccc.id}:nth-child(1)"
      expect(page).to have_css "tr#user_#{@user_bbb.id}:nth-child(2)"
      expect(page).to have_css "tr#user_#{@user_aaa.id}:nth-child(3)"
    end
  end
end
