class Image < ActiveRecord::Base
  mount_base64_uploader :file, ImageUploader

  validates :identifier, presence: true,
                         uniqueness: {scope: :page_id}
end