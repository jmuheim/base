class Code < ApplicationRecord
  has_paper_trail only: [:title, :identifier, :description, :html, :css, :js]

  belongs_to :page

  belongs_to :creator, class_name: User, foreign_key: :creator_id

  validates :identifier, presence: true,
                         uniqueness: {scope: :page_id}

  validates :creator_id, presence: true
  validates :title, presence: true

  def url
    matches = identifier.match(/^(.+)\-(.+)$/)
    "https://codepen.io/#{matches[1]}/pen/#{matches[2]}"
  end
end
