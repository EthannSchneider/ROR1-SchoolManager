class CreateScheduleSchoolClasses < ActiveRecord::Migration[8.1]
  def change
    create_join_table :schedules, :school_classes, table_name: :schedule_school_classes, column_options: { null: false } do |t|
      t.index %i[schedule_id school_class_id],
              unique: true,
              name: "index_schedule_school_classes_on_schedule_and_school_class"
      t.index %i[school_class_id schedule_id],
              name: "index_schedule_school_classes_on_school_class_and_schedule"
    end
  end
end
