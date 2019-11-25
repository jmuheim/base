class Image < ApplicationRecord
  has_paper_trail only: [:identifier, :file]

  # TODO: Add lock_version! Maybe a problem for base64 uploads, see https://github.com/lebedev-yury/carrierwave-base64/issues/23. Maybe it's enough to simply make the textarea disabled if no new image is pasted?!
  belongs_to :imageable, polymorphic: true

  mount_base64_uploader :file, ImageUploader

  belongs_to :creator, class_name: 'User'

  validates :identifier, presence: true,
                         uniqueness: {scope: [:imageable_type, :imageable_id]}

  validates :creator_id, presence: true

  validates :file, presence: true
end
