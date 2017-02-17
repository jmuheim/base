class Image < ActiveRecord::Base
  belongs_to :page

  mount_base64_uploader :file, ImageUploader

  validates :identifier, presence: true,
                         uniqueness: {scope: :page_id}
end