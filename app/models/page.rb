class Page < ApplicationRecord
  extend ActsAsTree::TreeWalker

  has_paper_trail only: [:title, :navigation_title, :content, :notes]
  accepts_pasted_images_for :content, :notes

  acts_as_tree order: :position, dependent: :restrict_with_error
  acts_as_list scope: [:parent_id]

  validates :title, presence: true,
                    uniqueness: {scope: :parent_id}

  # TODO: Auch sicher stellen, dass navigation_title_or_title unique ist!
  # validates :navigation_title, uniqueness: {scope: :parent_id},
  #                              if: -> { navigation_title.present? }

  def navigation_title_or_title
    navigation_title || title
  end

  def title_with_details
    "#{title} (##{id})"
  end
end
