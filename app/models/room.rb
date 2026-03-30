class Room < ApplicationRecord
  has_many :schedules, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
