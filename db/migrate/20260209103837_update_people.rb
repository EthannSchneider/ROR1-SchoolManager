class UpdatePeople < ActiveRecord::Migration[8.1]
  def change
    change_table :people do |t|
      t.string :firstname
      t.string :lastname
      t.string :avs_number
      t.string :phone_number
      t.string :street
      t.string :street_number
      t.string :postal_code
      t.string :city
      t.date :birthdate

      #  For single table inheritance
      t.string :type

      #  For collaborators
      t.date :contract_start
      t.date :contract_end

      #  For students
      t.date :admission_date
      t.date :end_date
    end
    add_index :people, :avs_number, unique: true
  end
end
