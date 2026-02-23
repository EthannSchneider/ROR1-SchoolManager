class Student < Person
  validates :admission_date, presence: true
  validates :end_date, presence: true
end
