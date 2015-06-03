# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#

require 'rails_helper'

describe User do
  it { should validate_presence_of(:name).with_message "can't be blank" }
  it { should validate_uniqueness_of(:name).case_insensitive }

  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end
  
    it 'versions name' do
      user = create :user, :donald
  
      expect {
        user.update_attributes! name: 'daisy'
      }.to change { user.name }.from('donald').to 'daisy'
    end

    it 'keeps old avatar file when assigning a new file' do
      user = create :user, :donald, :with_avatar

      user.update_attributes! avatar: dummy_file('other_image.jpg')
      original = user.versions.last.reify

      current_file  = user.avatar.file.file
      original_file = original.avatar.file.file

      expect(current_file).not_to eq original_file

      expect(File.exists?(current_file)).to eq true
      expect(File.exists?(original_file)).to eq true
    end

    it 'prevents overwriting original files with the same name' do
      user = create :user, :donald, :with_avatar

      ['same', 'other'].each do |path|
        user.update_attributes! avatar: dummy_file("#{path}_image_same_name/image.jpg")
        original = user.versions.last.reify

        current_file  = user.avatar.file.file
        original_file = original.avatar.file.file

        expect(current_file).not_to eq original_file

        expect(File.exists?(current_file)).to eq true
        expect(File.exists?(original_file)).to eq true
      end
    end

    it 'restores the original file name on reify' do
      user = create :user, :donald, :with_avatar

      # Check for original values
      expect(user.name).to eq 'donald'
      expect(user.avatar.file.filename).to match /-image\.jpg$/

      user.update_attributes! name: 'newname', avatar: dummy_file('other_image.jpg')

      # Make sure new values are applied
      expect(user.name).to eq 'newname'
      expect(user.avatar.file.filename).to match /-other_image\.jpg$/

      # Reify original version and reload
      user.versions.last.reify.save
      user = User.find user.id

      # Check for original values (again)
      expect(user.name).to eq 'donald' # Passes
      expect(user.avatar.file.filename).to match /-image\.jpg$/
    end

    it 'reloads the original file name on reload after reify' do
      pending
      user = create :user, :donald, :with_avatar

      user.update_attributes! avatar: dummy_file('other_image.jpg')
      user.versions.last.reify.save
      user.reload

      expect(user.avatar.file.filename).to match /-image\.jpg$/ # Fails: expected "1428993650-43424-5649-other_image.jpg" to match /-image\.jpg$/
    end

    # it 'deletes the versioned file when deleting a version'
  end

  # TODO: Why do we have these specs double?
  describe 'creating a user' do
    it 'validates presence of name' do
      @user = build :user, name: nil
      expect(@user).to have(1).error_on(:name)
    end

    it 'validates uniqueness of name' do
      create :user, name: 'josh'
      @user = build :user, name: 'josh'

      expect(@user).to have(1).error_on(:name)
    end

    it 'validates presence of email' do
      @user = build :user, email: nil
      expect(@user).to have(1).error_on(:email)
    end

    it 'validates presence of password' do
      @user = build :user, password: nil
      expect(@user).to have(1).error_on(:password)
    end
  end
end
