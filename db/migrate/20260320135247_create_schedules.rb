class CreateSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :schedules do |t|
      t.references :room, null: false, foreign_key: true
      t.references :unity, null: false, foreign_key: true
      t.date :day, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.index %i[room_id day start_time], name: "index_schedules_on_room_day_start_time"
      t.index %i[day start_time], name: "index_schedules_on_day_start_time"

      t.timestamps
    end
  end
end
