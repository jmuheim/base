class Page < ApplicationRecord
  accepts_pasted_images_for :content, :notes
  has_paper_trail only: [:title, :navigation_title, :content, :notes]

  validates :title, presence: true
  validates :navigation_title, presence: true
  validates :content, presence: true
end
