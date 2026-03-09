class Collaborator < Person
  has_many :responsable_school_classes,
    class_name: "SchoolClass",
    foreign_key: :responsable_id,
    inverse_of: :responsable,
    dependent: :nullify

  validates :contract_start, presence: true
  validates :contract_end, presence: false
  validates :type, inclusion: { in: %w[Collaborator Teacher Dean] }
end
