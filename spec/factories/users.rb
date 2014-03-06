# == Schema Information
# Schema version: 20140301093233
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
#  guest                  :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_name                  (name) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

FactoryGirl.define do
  factory :guest, class: User do
    guest true
  end

  factory :user do
    # Ffaker calls need to be in block?! See https://github.com/EmmanuelOga/ffaker/issues/121
    name                  { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              's3cur3p@ssw0rd'
    password_confirmation 's3cur3p@ssw0rd'
    confirmed_at          Time.now

    factory :admin do
      name                  'admin'
      email                 'admin@example.com'

      after(:create) do |user|
        user.roles << create(:role, name: 'admin')
      end
    end
  end
end
