class Project < ApplicationRecord
  has_paper_trail only: [:name, :description]
  belongs_to :customer
  
  validates :name, presence: true,
                   uniqueness: true
end
