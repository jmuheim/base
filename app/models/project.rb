class Project < ApplicationRecord
  has_paper_trail only: [:name, :description]
  has_many :timetracks, dependent: :restrict_with_error
  belongs_to :customer
  before_create :group_timetracks

  validates :name, presence: true,
                   uniqueness: true

  def group_timetracks
    Timetrack.group(:project_id)
  end

end
