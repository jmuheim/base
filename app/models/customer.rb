class Customer < ApplicationRecord
  has_paper_trail only: [:name, :address, :description]
  has_many :projects, dependent: :restrict_with_error

  validates :name, presence:   true,
                   uniqueness: true
end
