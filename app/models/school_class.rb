class SchoolClass < ApplicationRecord
  belongs_to :responsable, class_name: "Collaborator", inverse_of: :responsable_school_classes
  belongs_to :formation_plan, optional: true
  has_many :formation_modules, through: :formation_plan
  has_many :unities, through: :formation_modules
  has_many :students, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
