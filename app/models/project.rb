class Project < ApplicationRecord
  has_paper_trail only: [:name, :description]
  has_many :timetracks#, dependent: :restrict_with_error
  belongs_to :customer

  validates :name, presence: true,
                   uniqueness: true
end
