class Project < ApplicationRecord
  has_paper_trail only: [:name, :description]

  validates :name, presence: true,
                   uniqueness: true
end
