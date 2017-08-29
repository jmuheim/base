class Timetrack < ApplicationRecord
  has_paper_trail only: [:name, :description, :work_time, :bill_time]

  validates :name, presence: true
  validates :work_time, presence: true
end
