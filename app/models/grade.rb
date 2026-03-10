class Grade < ApplicationRecord
  belongs_to :student, inverse_of: :grades
  belongs_to :unity

  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6 }
  validates :test_date, presence: true
end
