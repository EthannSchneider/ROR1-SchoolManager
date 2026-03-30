class CreateScheduleCollaborators < ActiveRecord::Migration[8.1]
  def change
    create_join_table :schedules, :collaborators, table_name: :schedule_collaborators, column_options: { null: false } do |t|
      t.index %i[schedule_id collaborator_id],
              unique: true,
              name: "index_schedule_collaborators_on_schedule_and_collaborator"
      t.index %i[collaborator_id schedule_id],
              name: "index_schedule_collaborators_on_collaborator_and_schedule"
    end
  end
end
