class Student < Person
  belongs_to :school_class, optional: true

  validates :admission_date, presence: true
  validates :end_date, presence: true

  def formation_plan
    school_class&.formation_plan
  end
end
