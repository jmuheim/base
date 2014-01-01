# == Schema Information
#
# Table username: members
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
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
#  username               :string(255)
#

require 'spec_helper'

describe Member do
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of(:username).case_insensitive }
  # it { should allow_mass_assignment_of(:username) } # See https://github.com/thoughtbot/shoulda-matchers/issues/243

  it 'has a valid factory' do
    expect(create(:member)).to be_valid
  end
end
