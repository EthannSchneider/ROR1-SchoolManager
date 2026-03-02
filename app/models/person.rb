class Person < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable

  validates :email, presence: true, uniqueness: true
  validates :firstname, :lastname, :avs_number, presence: true
  validates :avs_number, uniqueness: true

  def age(on_date = Date.current)
    return nil if birthdate.blank?

    years = on_date.year - birthdate.year
    years -= 1 if on_date < birthdate + years.years
    years
  end
end
