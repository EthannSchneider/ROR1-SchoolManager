class FormationPlan < ApplicationRecord
  has_and_belongs_to_many :formation_modules
  has_many :school_classes

  validates :name, presence: true
end
