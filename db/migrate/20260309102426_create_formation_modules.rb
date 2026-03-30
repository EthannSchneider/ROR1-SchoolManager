class CreateFormationModules < ActiveRecord::Migration[8.1]
  def change
    create_table :formation_modules do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :formation_plans, :formation_modules do |t|
      t.index :formation_plan_id
      t.index :formation_module_id
    end
  end
end
