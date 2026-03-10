class Unity < ApplicationRecord
  belongs_to :formation_module
  has_many :grades

  validates :name, presence: true
end
