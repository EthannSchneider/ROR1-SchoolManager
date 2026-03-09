class AddFormationPlanToSchoolClasses < ActiveRecord::Migration[8.1]
  def change
    add_reference :school_classes, :formation_plan, foreign_key: true
  end
end
