class Page < ApplicationRecord
  extend ActsAsTree::TreeWalker

  has_paper_trail only: [:title, :navigation_title, :lead, :content, :notes]
  accepts_pasted_images_for :content, :notes

  acts_as_tree order: :position, dependent: :restrict_with_error
  acts_as_list scope: [:parent_id]

  belongs_to :creator, class_name: User, foreign_key: :creator_id

  validates :title, presence: true,
                    uniqueness: {scope: :parent_id}

  validates :creator_id, presence: true

  def navigation_title_or_title
    navigation_title || title
  end

  def title_with_details
    "#{title} (##{id})"
  end
end
