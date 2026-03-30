class CreateUnities < ActiveRecord::Migration[8.1]
  def change
    create_table :unities do |t|
      t.string :name

      t.timestamps
    end
  end
end
