class Page < ApplicationRecord
  scope :appear_in_navigation, -> { where(appear_in_navigation: true) }

  validates :title, presence: true
  validates :content, presence: true

  def navigation_title
    super.blank? ? title : super
  end
end
