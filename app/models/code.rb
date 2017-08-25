class Code < ApplicationRecord
  has_paper_trail only: [:identifier, :title, :html, :css, :js]

  belongs_to :page

  belongs_to :creator, class_name: User, foreign_key: :creator_id

  validates :identifier, presence: true,
                         uniqueness: {scope: :page_id},
                         format: /\A.+\-\w+\z/

  validates :creator_id, presence: true
  validates :title, presence: true
  validates :thumbnail_url, presence: true

  def pen_url
    url(:pen)
  end

  def debug_url
    url(:debug)
  end

  private

  def url(type)
    matches = identifier.match(/\A(.+)\-(\w+)\z/)
    "https://codepen.io/#{matches[1]}/#{type}/#{matches[2]}"
  end
end
