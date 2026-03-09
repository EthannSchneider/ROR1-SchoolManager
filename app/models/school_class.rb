class SchoolClass < ApplicationRecord
  belongs_to :responsable, class_name: "Collaborator", inverse_of: :responsable_school_classes
  has_many :students, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
