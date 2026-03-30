class FormationPlan < ApplicationRecord
  has_and_belongs_to_many :formation_modules
  has_many :school_classes
  has_many :unities, through: :formation_modules

  validates :name, presence: true
end
