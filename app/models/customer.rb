class Customer < ApplicationRecord
  has_paper_trail only: [:customer, :address, :description]

  validates :customer, presence: true,
                      uniqueness: true
end
