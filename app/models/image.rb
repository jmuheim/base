class Image < ApplicationRecord
  has_paper_trail only: :identifier

  # TODO: Add lock_version! Maybe a problem for base64 uploads, see https://github.com/lebedev-yury/carrierwave-base64/issues/23. Maybe it's enough to simply make the textarea disabled if no new image is pasted?!
  belongs_to :page

  mount_base64_uploader :file, ImageUploader

  belongs_to :creator, class_name: User, foreign_key: :creator_id

  validates :identifier, presence: true,
                         uniqueness: {scope: :page_id}

  validates :creator_id, presence: true
end