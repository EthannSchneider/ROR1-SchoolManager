class Unity < ApplicationRecord
  belongs_to :formation_module
  has_many :grades
  has_many :schedules, dependent: :restrict_with_error

  validates :name, presence: true
end
