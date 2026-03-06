class SchoolClass < ApplicationRecord
  belongs_to :responsable, class_name: "Collaborator"
  has_many :students, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
