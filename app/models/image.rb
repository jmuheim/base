class Image < ActiveRecord::Base
  # TODO: Add lock_version! Maybe a problem for base64 uploads, see https://github.com/lebedev-yury/carrierwave-base64/issues/23.
  belongs_to :page
  mount_base64_uploader :file, ImageUploader

  validates :identifier, presence: true,
                         uniqueness: {scope: :page_id}
end