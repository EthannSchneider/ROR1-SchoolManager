class Collaborator < Person
  validates :contract_start, presence: true
  validates :contract_end, presence: true
end
