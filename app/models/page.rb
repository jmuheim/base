class Page < ApplicationRecord
  extend ActsAsTree::TreeWalker

  has_paper_trail only: [:title, :navigation_title, :content, :notes]
  accepts_pasted_images_for :content, :notes

  acts_as_tree order: :position, dependent: :restrict_with_error
  acts_as_list scope: [:parent_id]

  validates :title, presence: true,
                    uniqueness: {scope: :parent_id}

  def navigation_title_or_title
    navigation_title || title
  end

  # Is there already something like that in the gem? See https://github.com/amerine/acts_as_tree/issues/49.
  def self.collection_tree
    pages = []
    walk_tree do |page, level|
      pages << page
    end
    pages
  end

  def collection_tree_without_self_and_descendants
    # This is very DB intensive. Is there a way to cache this? http://stackoverflow.com/questions/42529781/cache-a-result-set-for-a-class-method
    Page.collection_tree.reject { |page| descendants.include? page } - [self]
  end

  def title_with_details
    "#{title} (##{id})"
  end

  def previous_page
    if (index = Page.collection_tree.index(self)) == 0
      nil
    else
      Page.collection_tree[index - 1]
    end
  end

  def next_page
    Page.collection_tree[Page.collection_tree.index(self) + 1]
  end
end
