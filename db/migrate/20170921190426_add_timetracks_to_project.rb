class AddTimetrackToProjects < ActiveRecord::Migration[5.0]
  def change
    add_reference :timetracks, :project, foreign_key: true
  end
end
