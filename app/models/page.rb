class Page < ApplicationRecord
  has_paper_trail only: [:title, :navigation_title, :content, :notes]
  accepts_pasted_images_for :content, :notes

  validates :title, presence: true
end
