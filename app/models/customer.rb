class Customer < ApplicationRecord
  has_paper_trail only: [:name, :address, :description]

  validates :name, presence:   true,
                   uniqueness: true
end
