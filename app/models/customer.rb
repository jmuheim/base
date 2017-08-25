class Customer < ApplicationRecord
  has_paper_trail only: [:customer, :address]

  validates :customer, presence: true,
                      uniqueness: true
end
