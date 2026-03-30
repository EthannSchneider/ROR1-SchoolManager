class CreateGrades < ActiveRecord::Migration[8.1]
  def change
    create_table :grades do |t|
      t.decimal :value, precision: 2, scale: 1, null: false
      t.date :test_date, null: false
      t.references :student, null: false, foreign_key: { to_table: :people }
      t.references :unity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
