class Collaborator < Person
  has_many :responsable_school_classes,
    class_name: "SchoolClass",
    foreign_key: :responsable_id,
    inverse_of: :responsable,
    dependent: :nullify

  has_and_belongs_to_many :schedules, join_table: :schedule_collaborators

  validates :contract_start, presence: true
  validates :contract_end, presence: false
  validates :type, inclusion: { in: %w[Collaborator Teacher Dean] }
end
