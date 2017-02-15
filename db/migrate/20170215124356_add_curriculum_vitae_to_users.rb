class AddCurriculumVitaeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :curriculum_vitae, :string
  end
end
