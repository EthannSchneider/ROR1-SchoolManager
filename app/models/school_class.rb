class SchoolClass < ApplicationRecord
  belongs_to :responsable, class_name: "Collaborator", inverse_of: :responsable_school_classes
  belongs_to :formation_plan, optional: true
  has_many :formation_modules, through: :formation_plan
  has_many :unities, through: :formation_modules
  has_many :students, dependent: :nullify

  has_and_belongs_to_many :schedules, join_table: :schedule_school_classes

  validates :name, presence: true, uniqueness: true
end
