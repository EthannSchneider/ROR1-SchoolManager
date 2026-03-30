class Student < Person
  belongs_to :school_class, optional: true
  has_many :grades
  has_many :unities, through: :school_class
  has_many :schedules, through: :school_class

  validates :admission_date, presence: true
  validates :end_date, presence: true

  def formation_plan
    school_class&.formation_plan
  end
end
