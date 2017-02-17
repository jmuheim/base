class Page < ApplicationRecord
  has_paper_trail only: [:title, :navigation_title, :content, :notes]

  validates :title, presence: true
  validates :navigation_title, presence: true
  validates :content, presence: true

  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: -> attributes {
    # Ignore lock_version and _destroy when checking for attributes
    attributes.all? { |key, value| %w(_destroy lock_version).include?(key) || value.blank? }
  }

  def content_with_referenced_images
    content_with_images
  end

  def content_with_embedded_images
    content_with_images(false)
  end

  private

  def content_with_images(referenced = true)
    content.lines.map do |line|
      images.each do |image|
        line.gsub! /\(#{image.identifier}\)/, "(#{referenced ? image.file.url : image.file.path})"
      end

      line
    end.join
  end
end
