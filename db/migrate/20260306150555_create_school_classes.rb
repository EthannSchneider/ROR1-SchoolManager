class CreateSchoolClasses < ActiveRecord::Migration[8.1]
  def change
    create_table :school_classes do |t|
      t.string :name, null: false
      t.references :responsable, null: false, foreign_key: { to_table: :people }

      t.timestamps
    end

    add_index :school_classes, :name, unique: true

    add_reference :people, :school_class, foreign_key: true
  end
end
