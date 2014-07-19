# == Schema Information
# Schema version: 20140626201417
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
#  avatar                 :string(255)
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_name                  (name) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, authentication_keys: [:login]

  mount_uploader :avatar, AvatarUploader

  scope :guests,     -> { where(guest: true) }
  scope :registered, -> { where(guest: false) }

  attr_accessor :login

  before_validation :set_guest_name, if: -> { guest? }

  validates :name, presence: true
  validates :name, uniqueness: {case_sensitive: false},
                   unless: -> { guest? }
  validates :avatar, file_size: {maximum: (Rails.env.test? ? 5 : 100).kilobytes.to_i} # TODO: It would be nice to stub the maximum within the spec itself. See https://gist.github.com/chrisbloom7/1009861#comment-1220820

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['lower(name) = :value OR lower(email) = :value', { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def display_name
    guest? ? self.class.human_attribute_name(:guest_name) : name
  end

  def annex_and_destroy!(other)
    transaction do
      skip_confirmation_notification!

      other.delete
      other.attributes.except("id").each do |attribute, value|
        update_column attribute, value
      end

      self.save!
    end

    self
  end

  private

  def password_required?
    guest? ? false : super
  end

  def email_required?
    !guest?
  end

  def set_guest_name
    self.name = "guest-#{self.class.guests.maximum(:id).next rescue 1}"
  end
end
