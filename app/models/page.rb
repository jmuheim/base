class Page < ApplicationRecord
  has_paper_trail only: [:title, :navigation_title, :content, :notes]
  accepts_pasted_images_for :content, :notes

  validates :title, presence: true

  def content_with_page_references
    content_with_referenced_images.lines.map do |line|
      line.gsub!(/\[(.*?)\]\((.*?)\)/) do
        page = Page.find $2
        "![#{$1 || page.title}](#{link_to page})"
      end

      line
    end.join
  end
end
