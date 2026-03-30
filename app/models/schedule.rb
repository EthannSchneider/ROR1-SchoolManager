class Schedule < ApplicationRecord
  belongs_to :room
  belongs_to :unity

  has_and_belongs_to_many :collaborators, join_table: :schedule_collaborators
  has_and_belongs_to_many :school_classes, join_table: :schedule_school_classes

  validates :day, :start_time, :end_time, presence: true
  validate :start_time_before_end_time

  private

  def start_time_before_end_time
    return if start_time.blank? || end_time.blank?

    if start_time >= end_time
      errors.add(:end_time, "must be after the start time")
    end
  end
end
