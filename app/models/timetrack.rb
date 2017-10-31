class Timetrack < ApplicationRecord
  has_paper_trail only: [:name, :description, :work_time, :bill_time]
  belongs_to :project

  validates :name, presence: true
  validates :work_time, presence: true, numericality: { greater_than: 0 }
  validates :bill_time, numericality: { less_than_or_equal_to: :work_time, greater_than_or_equal_to: 0 }, if: :work_time?

end
