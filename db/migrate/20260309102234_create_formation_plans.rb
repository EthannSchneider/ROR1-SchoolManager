class CreateFormationPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :formation_plans do |t|
      t.string :name

      t.timestamps
    end
  end
end
