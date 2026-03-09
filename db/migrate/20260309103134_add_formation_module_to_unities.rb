class AddFormationModuleToUnities < ActiveRecord::Migration[8.1]
  def change
    add_reference :unities, :formation_module, null: false, foreign_key: true
  end
end
