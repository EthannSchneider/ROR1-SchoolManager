class Collaborator < Person
  validates :contract_start, presence: true
  validates :contract_end, presence: false
  validates :type, inclusion: { in: %w[Collaborator Teacher Dean] }
end
