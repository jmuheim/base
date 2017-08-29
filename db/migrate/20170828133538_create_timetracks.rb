class CreateTimetracks < ActiveRecord::Migration[5.0]
  def change
    create_table :timetracks do |t|
      t.string  :name
      t.text    :description
      t.decimal :work_time, precision: 5, scale: 2
      t.decimal :bill_time, precision: 5, scale: 2

      t.timestamps
    end
  end
end
