class User < ApplicationRecord
  extend Enumerize
  include Humanizer

  has_paper_trail only: [:name, :about_de, :about_en, :role]

  extend Mobility
  translates :about

  attr_accessor :bypass_humanizer
  require_human_on :create, unless: :bypass_humanizer

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, authentication_keys: [:login]

  mount_base64_uploader :avatar, AvatarUploader
  mount_uploader :curriculum_vitae, DocumentUploader

  has_many :created_codes, foreign_key: :creator_id, class_name: 'Code',
                           dependent: :restrict_with_error

  has_many :created_images, foreign_key: :creator_id, class_name: 'Image',
                            dependent: :restrict_with_error

  has_many :created_pages, foreign_key: :creator_id, class_name: 'Page',
                           dependent: :restrict_with_error

  enumerize :role, in: [:user, :editor, :admin], default: :user

  attr_accessor :login

  validates :name, presence: true
  validates :name, uniqueness: {case_sensitive: false}
  validates :curriculum_vitae, file_size: {maximum: (Rails.env.test? ? 15 : 500).kilobytes.to_i} # TODO: It would be nice to stub the maximum within the spec itself. See https://gist.github.com/chrisbloom7/1009861#comment-1220820
  validates :avatar, file_size: {maximum: (Rails.env.test? ? 15 : 500).kilobytes.to_i} # TODO: It would be nice to stub the maximum within the spec itself. See https://gist.github.com/chrisbloom7/1009861#comment-1220820

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(name) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions.to_hash).first
    end
  end

  def active_for_authentication?
    super && !disabled
  end
end
