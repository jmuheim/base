class Page < ApplicationRecord
  has_paper_trail only: [:title, :navigation_title, :content, :notes]

  validates :title, presence: true
  validates :navigation_title, presence: true
  validates :content, presence: true
end
