class Page < ApplicationRecord
  scope :appear_in_navigation, -> { where(appear_in_navigation: true) }

  validates :title, presence: true
  validates :navigation_title, presence: true
  validates :content, presence: true
end
