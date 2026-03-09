class FormationModule < ApplicationRecord
  has_and_belongs_to_many :formation_plans
  has_many :unities, dependent: :destroy

  validates :name, presence: true
end
