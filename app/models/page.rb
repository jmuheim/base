class Page < ApplicationRecord
  extend ActsAsTree::TreeWalker

  extend Mobility
  translates :title, :navigation_title, :lead, :content

  has_paper_trail only: [:title_de,
                         :title_en,
                         :navigation_title_de,
                         :navigation_title_en,
                         :lead_de,
                         :lead_en,
                         :content_de,
                         :content_en,
                         :notes]

  accepts_pastables_for :content, :notes

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
