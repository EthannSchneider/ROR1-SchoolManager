class FormationPlan < ApplicationRecord
  has_and_belongs_to_many :formation_modules

  validates :name, presence: true
end
